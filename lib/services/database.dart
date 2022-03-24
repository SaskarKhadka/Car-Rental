import 'dart:io';
import 'package:car_rental/components/custom_exception.dart';
import 'package:car_rental/model/car.dart';
import 'package:car_rental/model/order.dart';
import 'package:car_rental/model/user.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/cloudStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static final firestoreInstance = FirebaseFirestore.instance;

  static Future<void> addUser(Map<String, dynamic> userData) async {
    final userRef = firestoreInstance.collection("users").doc();
    userData["id"] = Authentication.userID;
    userData["profileUrl"] = await CloudStorage.genericProfileUrl();
    await userRef.set(userData);
  }

  static Future<bool> userExists(String? uid) async {
    final query =
        firestoreInstance.collection("users").where("id", isEqualTo: uid!);
    final document = await query.get();
    return document.docs.isNotEmpty;
  }

  static Future<bool> isAdmin() async {
    bool admin;
    print(Authentication.userID);
    final snapshot = await firestoreInstance
        .collection('users')
        .where('id', isEqualTo: Authentication.userID)
        .get();
    try {
      admin = snapshot.docs[0].data()["isAdmin"] == null ? false : true;
    } catch (ex) {
      return false;
    }
    return admin;
  }

  static Stream<QuerySnapshot> requestsStream() {
    return firestoreInstance.collection("requests").snapshots();
  }

  static saveCar(Map<String, dynamic> carData) async {
    final carRef = firestoreInstance.collection("cars").doc();
    // final user = Car.fromData(carData: carData).toJson;
    await carRef.set(carData);
  }

  static updateCar(Map<String, dynamic> carData, String? docID) async {
    final car = firestoreInstance.collection("cars").doc(docID);
    await car.update(carData);
  }

  static Stream<List<Car?>> carsStream() {
    return firestoreInstance
        .collection("cars")
        .snapshots()
        .map((querySnap) => querySnap.docs
            .map(
              (queryDocSnap) => Car.fromData(
                carData: queryDocSnap.data(),
                id: queryDocSnap.id,
              ),
            )
            .toList());
  }

  static Future<void> deleteCar({String? id}) async {
    await firestoreInstance.collection("cars").doc(id).delete();
  }

  static bool? checkAvailability(
      Map<String, dynamic> data, DateTime? pickUp, DateTime? dropOff) {
    bool? isAvailable = false;
    if (data["availability"] == null) {
      return true;
    } else {
      Map<String, dynamic> availablityData = data["availability"];
      for (String key in availablityData.keys) {
        List<String>? pickUpDateStr =
            availablityData[key]["pickUpDate"].toString().split("/");
        List<String>? dropOffDateStr =
            availablityData[key]["dropOffDate"].toString().split("/");

        DateTime? pickUpDate = DateTime(
          int.parse(pickUpDateStr[0]),
          int.parse(pickUpDateStr[1]),
          int.parse(pickUpDateStr[2]),
        );

        DateTime? dropOffDate = DateTime(
          int.parse(dropOffDateStr[0]),
          int.parse(dropOffDateStr[1]),
          int.parse(dropOffDateStr[2]),
        );
        if ((pickUp!.isBefore(pickUpDate) && dropOff!.isBefore(pickUpDate)) ||
            (pickUp.isAfter(dropOffDate) && dropOff!.isAfter(dropOffDate))) {
          isAvailable = true;
        } else {
          return false;
        }
      }
      return isAvailable;
    }
  }

  static Stream<List<Car?>> availableCarsStream(
      String? pickUpDate, String? dropOffDate) {
    return firestoreInstance
        .collection("cars")
        .snapshots()
        .map((querySnap) => querySnap.docs.map((queryDocSnap) {
              final carData = queryDocSnap.data();
              final pickUp = pickUpDate!.split("/");
              final dropOff = dropOffDate!.split("/");
              if (checkAvailability(
                carData,
                DateTime(
                  int.parse(pickUp[0]),
                  int.parse(pickUp[1]),
                  int.parse(pickUp[2]),
                ),
                DateTime(
                  int.parse(dropOff[0]),
                  int.parse(dropOff[1]),
                  int.parse(dropOff[2]),
                ),
              )!) {
                return Car.fromData(
                  carData: carData,
                  id: queryDocSnap.id,
                );
              }
            }).toList());
  }

  // static placeOrder(Map<String, dynamic> orderDetails) async {
  //   final orderRef = firestoreInstance.collection("orders").doc();
  //   await orderRef.set(orderDetails);
  // }

  static Stream<List<Order?>> userOrdersStream() {
    return firestoreInstance
        .collection("orders")
        .where("placedBy", isEqualTo: Authentication.userID)
        .snapshots()
        .map((querySnap) => querySnap.docs.map((queryDocSnap) {
              final orderData = queryDocSnap.data();
              // print(orderData);
              if (orderData["placedBy"] == Authentication.userID) {
                return Order.fromData(
                  orderData: orderData,
                  id: queryDocSnap.id,
                );
              }
            }).toList());
  }

  static Stream<List<Order?>> allOrders() {
    return firestoreInstance
        .collection("orders")
        .snapshots()
        .map((querySnap) => querySnap.docs.map((queryDocSnap) {
              final orderData = queryDocSnap.data();
              // print(orderData);
              return Order.fromData(
                orderData: orderData,
                id: queryDocSnap.id,
              );
            }).toList());
  }

  static Future<int> totalOrder(String? userID) async {
    final userQuerySnap = await firestoreInstance
        .collection("users")
        .where(
          "id",
          isEqualTo: userID,
        )
        .get();
    final userDocSnap = userQuerySnap.docs[0];
    return userDocSnap.data()["totalOrder"] ?? 0;
  }

  // static updateOrderNumber(int? by) async {
  //   final totalOrders = await totalOrder();
  //   final userRef = firestoreInstance
  //       .collection("users")
  //       .where("id", isEqualTo: Authentication.userID)
  //       .get();
  // }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> carDetailsStream(
      String carID) {
    return firestoreInstance.collection("cars").doc(carID).snapshots();
  }

  static updateProfileUrl(String? url) async {
    final querySnap = await firestoreInstance
        .collection("users")
        .where("id", isEqualTo: Authentication.userID)
        .get();
    final userDocID = querySnap.docs[0].id;
    await firestoreInstance
        .collection("users")
        .doc(userDocID)
        .update({"profileUrl": url!});
  }

  static Stream<List<User?>> getUser(String? uid) {
    return firestoreInstance
        .collection("users")
        .where("id", isEqualTo: uid)
        .snapshots()
        .map((querySnap) => querySnap.docs.map((queryDocSnap) {
              final userData = queryDocSnap.data();
              return User.fromData(
                userData: userData,
                id: queryDocSnap.id,
              );
            }).toList());
  }

  static orderPlacingTransaction(Map<String, dynamic> orderDetails) async {
    try {
      final orderRef = firestoreInstance.collection("orders").doc();
      final user = await firestoreInstance
          .collection("users")
          .where("id", isEqualTo: orderDetails["placedBy"])
          .get();
      final userRef =
          firestoreInstance.collection("users").doc(user.docs[0].id);
      final carRef =
          firestoreInstance.collection("cars").doc(orderDetails["car"]);
      final totalOrders = await totalOrder(Authentication.userID);

      await firestoreInstance.runTransaction((transaction) async {
        transaction.set(orderRef, orderDetails);

        transaction.update(carRef, {
          "availability.${orderRef.id}": {
            "pickUpDate": orderDetails["pickUpDate"],
            "dropOffDate": orderDetails["dropOffDate"]
          }
        });
        transaction.update(userRef, {
          "totalOrder": totalOrders + 1,
        });
      });
    } on FirebaseException catch (ex) {
      throw CustomException(ex.message!);
    } on RangeError catch (ex) {
      throw CustomException(ex.message);
    } on SocketException catch (ex) {
      throw CustomException(ex.message);
    }
  }

  static orderDeleteTransaction(
    String? orderID,
    String? carID,
    String? userID,
  ) async {
    try {
      final orderRef = firestoreInstance.collection("orders").doc(orderID);
      final user = await firestoreInstance
          .collection("users")
          .where("id", isEqualTo: userID)
          .get();
      final userRef =
          firestoreInstance.collection("users").doc(user.docs[0].id);
      final carRef = firestoreInstance.collection("cars").doc(carID);
      final carDocSnap = await carRef.get();
      final carAvailability =
          carDocSnap.data()!["availability"] as Map<String, dynamic>;
      carAvailability.remove(orderRef.id);
      final totalOrders = await totalOrder(userID);

      await firestoreInstance.runTransaction((transaction) async {
        transaction.delete(orderRef);

        transaction.update(carRef, {"availability": carAvailability});
        transaction.update(userRef, {
          "totalOrder": totalOrders - 1,
        });
      });
    } on FirebaseException catch (ex) {
      throw CustomException(ex.message!);
    } on RangeError catch (ex) {
      throw CustomException(ex.message);
    } on SocketException catch (ex) {
      throw CustomException(ex.message);
    }
  }
}
