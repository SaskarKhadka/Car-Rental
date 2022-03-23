import 'package:car_rental/components/car_details_dialog.dart';
import 'package:car_rental/components/continue_dialog.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/model/car.dart';
import 'package:car_rental/model/order.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class UserOrders extends StatelessWidget {
  const UserOrders({Key? key}) : super(key: key);

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
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: Database.data(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'You have no orders',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            );
          }
          final orders = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: orders.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if (orders[index].data()["placedBy"] != Authentication.userID) {
                return Container();
              }
              final orderData = orders[index];
              final Order? order =
                  Order.fromData(orderData: orderData.data(), id: orderData.id);
              final todaysDate = [
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day
              ];
              final pickUpDate = order!.pickUpDate.split("/");
              print(todaysDate);
              print(pickUpDate);

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
                                  "Date: ${order.pickUpDate}",
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
                                      brand: car.brand,
                                      type: car.type,
                                      totalSeats: car.numberOfSeats,
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
                            onTap: () {
                              //do something
                            },
                            color: Colors.blue,
                            icon: EvaIcons.messageCircleOutline,
                          ),
                          todaysDate[1] > int.parse(pickUpDate[1]) ||
                                  (todaysDate[1] == int.parse(pickUpDate[1]) &&
                                      todaysDate[2] >= int.parse(pickUpDate[2]))
                              ? iconButton(
                                  onTap: () {
                                    // do something
                                  },
                                  color: const Color.fromARGB(255, 89, 180, 66),
                                  icon: Icons.payment_outlined,
                                )
                              : iconButton(
                                  onTap: () {
                                    // do something
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
