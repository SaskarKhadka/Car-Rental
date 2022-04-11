import 'package:car_rental/components/continue_dialog.dart';
import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/custom_exception.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/model/car.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:car_rental/services/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Booking extends StatefulWidget {
  static const String id = "/booking";
  final Map<String, dynamic>? args;
  const Booking({Key? key, this.args}) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  @override
  void initState() {
    print(widget.args!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: Database.carDetailsStream(widget.args!["car"]),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'No cars are available on the given date',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              );
            }
            final Car car = Car.fromData(
                carData: snapshot.data!.data()!, id: widget.args!["car"]);
            return Padding(
              padding: const EdgeInsets.only(
                top: 65.0,
                // bottom: 30.0,
                right: 20.0,
                left: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Image.network(
                              car.coverPicUrl,
                              height: 120.0,
                              width: 200.0,
                              fit: BoxFit.fill,
                              loadingBuilder: (_, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return CircularProgressIndicator(
                                  color: Colors.white,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.025,
                          ),
                          const SizedBox(
                            width: 180,
                            child: Divider(
                              thickness: 2,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          boxedItem("Brand: ", car.brand, Colors.grey),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          boxedItem("Type: ", car.type, Colors.grey),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          boxedItem(
                              "Total Seats: ", car.numberOfSeats, Colors.grey),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          boxedItem(
                              "Mileage: ", "${car.mileage} km/lt", Colors.grey),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          boxedItem("Registration: ", car.registrationNumber,
                              Colors.grey),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          boxedItem("Pickup Date: ",
                              "${widget.args!["pickUpDate"]}", Colors.grey),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          boxedItem("Dropoff Date: ",
                              "${widget.args!["dropOffDate"]}", Colors.grey),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          boxedItem("Pickup Time: ",
                              "${widget.args!["pickUpTime"]}", Colors.grey),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          boxedItem("Dropoff Time: ",
                              "${widget.args!["dropOffTime"]}", Colors.grey),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => continueDialog(
                                  title: "Place Order",
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

                                    final int totalOrders =
                                        await Database.totalOrder(
                                            Authentication.userID);
                                    if (totalOrders == 3) {
                                      navigatorKey.currentState!.pop();
                                      navigatorKey.currentState!.pop();
                                      navigatorKey.currentState!.pop();
                                      navigatorKey.currentState!.pop();
                                      return getToast(
                                        message:
                                            "You can only place 3 orders at a time",
                                        color: Colors.red,
                                      );
                                    }
                                    final bool verificationExists =
                                        await Database.verificationExists();
                                    if (!verificationExists) {
                                      navigatorKey.currentState!.pop();
                                      navigatorKey.currentState!.pop();
                                      navigatorKey.currentState!.pop();
                                      navigatorKey.currentState!.pop();
                                      return getToast(
                                        message:
                                            "You need to upload your Citizenship and Lisence picture",
                                        color: Colors.red,
                                      );
                                    }
                                    final bool phoneNumberExists =
                                        await Database.phoneNumberExists();
                                    if (phoneNumberExists) {
                                      widget.args!["placedBy"] =
                                          Authentication.userID;
                                      widget.args!["timestamp"] =
                                          DateTime.now().toString();
                                      // await Database.placeOrder(
                                      //     args!);
                                      try {
                                        await Database.orderPlacingTransaction(
                                            widget.args!);
                                        navigatorKey.currentState!.pop();
                                        navigatorKey.currentState!.pop();
                                        navigatorKey.currentState!.pop();
                                        navigatorKey.currentState!.pop();
                                        getToast(
                                          message: "Your order has been placed",
                                          color: Colors.green,
                                        );
                                        try {
                                          final tokens =
                                              await Database.getAdminsToken();
                                          await NotificationHandler
                                              .sendNotification(
                                            token: tokens[0],
                                            body: "You have a new order",
                                            title: "New Order",
                                          );
                                        } catch (ex) {
                                          print(ex.toString());
                                        }
                                      } on CustomException catch (ex) {
                                        navigatorKey.currentState!.pop();
                                        navigatorKey.currentState!.pop();
                                        navigatorKey.currentState!.pop();
                                        navigatorKey.currentState!.pop();
                                        return getToast(
                                          message:
                                              "Your order couldnot be placed",
                                          color: Colors.red,
                                        );
                                      }
                                    } else {
                                      navigatorKey.currentState!.pop();
                                      navigatorKey.currentState!.pop();
                                      navigatorKey.currentState!.pop();
                                      navigatorKey.currentState!.pop();
                                      return getToast(
                                        message:
                                            "You need to set your phone number.",
                                        color: Colors.red,
                                      );
                                    }
                                  },
                                  onNo: () {
                                    navigatorKey.currentState!.pop();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 20.0,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5962DA),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const Text(
                                'BOOK NOW',
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: Colors.white,
                                  letterSpacing: 1.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }

  boxedItem(String? title, String? text, Color? color) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(5, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Icon(
            //   icon!,
            //   color: Colors.black,
            //   size: 22.0,
            // ),
            // const SizedBox(
            //   width: 15.0,
            // ),
            Flexible(
              child: Text(
                title!,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                  fontSize: 16.0,
                ),
              ),
            ),

            Flexible(
              child: Text(
                text!,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
