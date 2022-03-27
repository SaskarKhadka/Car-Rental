import 'package:car_rental/components/car_details_dialog.dart';
import 'package:car_rental/components/continue_dialog.dart';
import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/custom_exception.dart';
import 'package:car_rental/components/custom_text_field.dart';
import 'package:car_rental/constants/constants.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/model/car.dart';
import 'package:car_rental/model/order.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/screens/user/payment_screen.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:car_rental/services/google_auth.dart';
import 'package:car_rental/services/notification.dart';
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

class UserOrdersStream extends StatefulWidget {
  @override
  State<UserOrdersStream> createState() => _UserOrdersStreamState();
}

class _UserOrdersStreamState extends State<UserOrdersStream> {
  final bargainController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
        stream: Database.userOrdersStream(),
        builder: (context, snapshot) {
          // print(snapshot.data!.docs);
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
          final orders = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: orders.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              // if (orders[index].data()["placedBy"] != Authentication.userID) {
              //   return Container();
              // }
              final order = orders[index];
              // final Order? order =
              //     Order.fromData(orderData: orderData, id: orderData.id);
              final todaysDate = DateTime.now();
              final pickUpDateList = order!.pickUpDate.split("/");
              final pickUpDate = DateTime(int.parse(pickUpDateList[0]),
                  int.parse(pickUpDateList[1]), int.parse(pickUpDateList[2]));
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
                                  "Time: ${order.pickUpTime}",
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
                                  "Time: ${order.dropOffTime}",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Bargain: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: "Montserrat",
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: order.endBargain == "true"
                                ? () {
                                    getToast(
                                      message: "Bargain has ended",
                                      color: Colors.red,
                                    );
                                  }
                                : () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Form(
                                            key: formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  "Enter your new bargain.",
                                                  style: TextStyle(
                                                    // color: Color(0xff4C276C),
                                                    color: Colors.black,
                                                    fontFamily: "Montserrat",
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20.0,
                                                ),
                                                CustomTextField(
                                                  controller: bargainController,
                                                  labelText: "Bragain",
                                                  icon: Icons.payment_outlined,
                                                  isAmount: true,
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(
                                                  height: 20.0,
                                                ),
                                                CustomButton(
                                                  onPressed: () async {
                                                    if ((formKey.currentState!
                                                        .validate())) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                              backgroundColor:
                                                                  Colors.black,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                      try {
                                                        await Database
                                                            .updateBargain(
                                                          order.docID,
                                                          bargainController.text
                                                              .trim(),
                                                        );
                                                        try {
                                                          final token =
                                                              await Database
                                                                  .getAdminsToken();
                                                          await NotificationHandler
                                                              .sendNotification(
                                                                  token:
                                                                      token[0],
                                                                  body:
                                                                      "The new is bargain is Rs. ${order.bargain}",
                                                                  title:
                                                                      "New Bargain");
                                                        } catch (ex) {}

                                                        navigatorKey
                                                            .currentState!
                                                            .pop();
                                                        navigatorKey
                                                            .currentState!
                                                            .pop();
                                                        getToast(
                                                          message:
                                                              "Your bargain was updated",
                                                          color: Colors.green,
                                                        );
                                                      } on FirebaseException catch (ex) {
                                                        navigatorKey
                                                            .currentState!
                                                            .pop();
                                                        navigatorKey
                                                            .currentState!
                                                            .pop();
                                                        getToast(
                                                          message:
                                                              "Your bargain was not updated",
                                                          color: Colors.red,
                                                        );
                                                      }
                                                    }
                                                  },
                                                  width: double.infinity,
                                                  buttonColor: Colors.black,
                                                  buttonContent: const Text(
                                                    "CONFIRM",
                                                    style:
                                                        kButtonContentTextStye,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 15.0,
                              ),
                              decoration: BoxDecoration(
                                // color: Colors.grey,
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                "Rs. ${order.bargain}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
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
                          todaysDate.isAfter(pickUpDate)
                              ? iconButton(
                                  onTap: () {
                                    // do something
                                    navigatorKey.currentState!.pushNamed(
                                      Payment.id,
                                      arguments: {
                                        "car": order.car,
                                        "orderID": order.docID,
                                        "amount": order.bargain,
                                      },
                                    );
                                  },
                                  color: const Color.fromARGB(255, 89, 180, 66),
                                  icon: Icons.payment_outlined,
                                )
                              : iconButton(
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => continueDialog(
                                        title: "Delete Order",
                                        message:
                                            "Are you sure you want to continue?",
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
                                            await Database
                                                .orderDeleteTransaction(
                                              order.docID,
                                              order.car,
                                              order.placedBy,
                                            );
                                          } on CustomException catch (ex) {
                                            navigatorKey.currentState!.pop();
                                            return getToast(
                                              message:
                                                  "Your order was not deleted",
                                              color: Colors.red,
                                            );
                                          }
                                          navigatorKey.currentState!.pop();
                                          getToast(
                                            message:
                                                "Your order has been deleted",
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
