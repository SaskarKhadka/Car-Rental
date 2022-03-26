import 'package:car_rental/components/car_details_dialog.dart';
import 'package:car_rental/components/continue_dialog.dart';
import 'package:car_rental/components/custom_exception.dart';
import 'package:car_rental/components/profile_dialog.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/model/car.dart';
import 'package:car_rental/model/order.dart';
import 'package:car_rental/model/user.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/screens/user/payment_screen.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:car_rental/services/google_auth.dart';
import 'package:car_rental/services/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrdersForTodayAndTomorrow extends StatelessWidget {
  const OrdersForTodayAndTomorrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        // drawer: DrawerItems(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 67,
          elevation: 2,
          shadowColor: Colors.white,
          title: const Padding(
            padding: EdgeInsets.only(
              top: 8.0,
              left: 16.0,
            ),
            child: Text(
              'Orders',
              style: TextStyle(
                fontFamily: "Montserrat",
                // color: Color(0xff131313),
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.5,
                // decoration: TextDecoration.underline,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  try {
                    await GoogleAuthentication.signOut();
                    await Authentication.signOut();
                    navigatorKey.currentState!
                        .pushNamedAndRemoveUntil(Signin.id, (route) => false);
                  } on PlatformException catch (ex) {
                    await Authentication.signOut();
                    navigatorKey.currentState!
                        .pushNamedAndRemoveUntil(Signin.id, (route) => false);
                  } on CustomException catch (ex) {
                    getToast(
                      message: "Couldnot sign out",
                      color: Colors.red,
                    );
                  }
                },
                child: const Icon(
                  EvaIcons.logOutOutline,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
          ],
        ),
        body: Scrollbar(
          child: UserOrdersStream(),
        ),
      ),
    );
  }
}

class UserOrdersStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      child: StreamBuilder<List<Order?>>(
        stream: Database.comingUpOrders(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'You have no recent orders',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            );
          }
          final orders = snapshot.data!;
          print(orders);
          return ListView.builder(
            shrinkWrap: true,
            itemCount: orders.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 30.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: const Color(0xFF18171A),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 5.0,
                        offset: Offset(7, 7),
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 7.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Pickup:",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  "Date: ${order!.pickUpDate}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  "Location: ${order.pickUpLocation}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                const SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                          // const SizedBox(
                          //   width: 30.0,
                          // ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Dropoff:",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  "Date: ${order.dropOffDate}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  "Location: ${order.dropOffLocation}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                const SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   width: 30.0,
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: StreamBuilder<List<User?>>(
                                stream: Database.getUser(order.placedBy),
                                builder: (context, snapshot) {
                                  print(order.placedBy);
                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const CircularProgressIndicator(
                                      color: Colors.white,
                                      backgroundColor: Colors.white54,
                                    );
                                  }
                                  User? user = snapshot.data![0];
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ProfileDialog(
                                              name: user!.name,
                                              email: user.email,
                                              phoneNumber: user.phoneNumber,
                                              profileUrl: user.profileUrl,
                                              citizenship: user.citizenship,
                                              lisence: user.lisence,
                                            );
                                          });
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20.0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(70),
                                        child: Image.network(user!.profileUrl,
                                            fit: BoxFit.fill,
                                            height: 40,
                                            width: 40, loadingBuilder:
                                                (_, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return CircularProgressIndicator(
                                            color: Colors.black,
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          );
                                          // imageUrl: this.strImageURL,
                                        } //
                                            ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          iconButton(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: Database.carDetailsStream(order.car),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          CircularProgressIndicator(
                                            color: Colors.white,
                                            backgroundColor: Colors.black,
                                          ),
                                        ],
                                      );
                                    }

                                    final Car car = Car.fromData(
                                        carData: snapshot.data!.data()!,
                                        id: order.car);
                                    return CarDetailsDialog(
                                      coverPicUrl: car.coverPicUrl,
                                      brand: car.brand,
                                      type: car.type,
                                      numberOfSeats: car.numberOfSeats,
                                      mileage: car.mileage,
                                      registrationNumber:
                                          car.registrationNumber,
                                      ratePerDay: car.ratePerDay,
                                    );
                                  },
                                ),
                              );
                            },
                            color: Colors.blue[400],
                            icon: EvaIcons.carOutline,
                          ),
                          iconButton(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => continueDialog(
                                  title: "Delete Order",
                                  message: "Are you sure you want to continue?",
                                  onYes: () async {
                                    navigatorKey.currentState!.pop();
                                    showDialog(
                                      context: context,
                                      builder: (context) => Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          CircularProgressIndicator(
                                            color: Colors.white,
                                            backgroundColor: Colors.black,
                                          ),
                                        ],
                                      ),
                                    );
                                    try {
                                      await Database.orderDeleteTransaction(
                                        order.docID,
                                        order.car,
                                        order.placedBy,
                                      );

                                      try {
                                        NotificationHandler.sendNotification(
                                          token: await Database.getToken(
                                              order.placedBy),
                                          body: "Your order was deleted",
                                          title: "Order Deleted",
                                        );
                                      } catch (ex) {}
                                    } on CustomException catch (ex) {
                                      navigatorKey.currentState!.pop();
                                      return getToast(
                                        message:
                                            "The order couldnot be deleted",
                                        color: Colors.red,
                                      );
                                    }
                                    navigatorKey.currentState!.pop();
                                    getToast(
                                      message: "The order has been deleted",
                                      color: Colors.green,
                                    );
                                  },
                                  onNo: () {
                                    navigatorKey.currentState!.pop();
                                  },
                                ),
                              );
                            },
                            color: const Color(0xFFDA5D59),
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  onCarTap() {}

  iconButton({
    VoidCallback? onTap,
    Color? color,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              16.0,
            ),
          ),
        ),
        child: Icon(
          // Icons.cancel,
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
