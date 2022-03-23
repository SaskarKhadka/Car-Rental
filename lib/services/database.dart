import 'dart:io';
import 'package:car_rental/model/car.dart';
import 'package:car_rental/model/order.dart';
import 'package:car_rental/model/user.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static final firestoreInstance = FirebaseFirestore.instance;

  static Future<void> addUser(Map<String, dynamic> userData) async {
    final userRef = firestoreInstance.collection("users").doc();
    // final user =
    //     User.fromData(userData: userData, id: Authentication.userID).toJson;
    userData["id"] = Authentication.userID;
    await userRef.set(userData);
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

  static placeOrder(Map<String, dynamic> orderDetails) async {
    final orderRef = firestoreInstance.collection("orders").doc();
    await orderRef.set(orderDetails);
  }

  static Stream<List<Order>> ordersStream() {
    // firestoreInstance.collection("orders").snapshots().forEach((element) {
    //   final data = element.docs;
    //   for (final value in data) {
    //     print(value.data());
    //   }
    // });
    return firestoreInstance
        .collection("orders")
        .where("placedBy", isEqualTo: Authentication.userID)
        .snapshots()
        .map((querySnap) => querySnap.docs.map((queryDocSnap) {
              final orderData = queryDocSnap.data();
              print(orderData);
              return Order.fromData(
                orderData: orderData,
                id: queryDocSnap.id,
              );
            }).toList());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> data() {
    return firestoreInstance.collection("orders").snapshots();
  }

  static int totalOrder() {
    return 1;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> carDetailsStream(
      String carID) {
    return firestoreInstance.collection("cars").doc(carID).snapshots();
  }
}
