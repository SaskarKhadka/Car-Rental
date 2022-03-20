import 'package:car_rental/main.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class Requests extends StatelessWidget {
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
                // color: Color(0xff131313),
                color: Colors.white,
                fontSize: 26,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w400,
                letterSpacing: 1.5,
                // decoration: TextDecoration.underline,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            const Padding(
              padding: EdgeInsets.only(
                top: 8.0,
                left: 20.0,
                right: 15.0,
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                  textTheme: const TextTheme().apply(bodyColor: Colors.black),
                  dividerColor: Colors.black,
                  iconTheme: const IconThemeData(color: Colors.white)),
              child: PopupMenuButton<int>(
                color: Colors.white,
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      "About us",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.black,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ),
                  const PopupMenuItem<int>(
                      value: 1,
                      child: Text(
                        "Help",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Colors.black,
                          letterSpacing: 1.8,
                        ),
                      )),
                  const PopupMenuDivider(),
                  PopupMenuItem<int>(
                      value: 2,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Sign Out",
                            style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 1.8,
                                fontFamily: "Montserrat"),
                          )
                        ],
                      )),
                ],
                onSelected: (item) => selectedItem(context, item),
                offset: const Offset(0, 70),
              ),
            ),
          ],
        ),
        body: Scrollbar(
          child: OrdersStream(),
        ),
      ),
    );
  }
}

Future<void> selectedItem(BuildContext context, int item) async {
  switch (item) {
    case 0:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => AboutPage()),
      // );
      break;
    case 1:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HelpPage()),
      // );
      break;
    case 2:
      await Authentication.signOut();
      navigatorKey.currentState!
          .pushNamedAndRemoveUntil(Signin.id, (route) => false);
      break;
  }
}

class OrdersStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // return Container();
    return StreamBuilder<QuerySnapshot>(
      stream: Database.requestsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
        // print(snapshot.data.snapshot.value);
        final orders = snapshot.data!.docs;

        // List<String> orderKeys = [];
        // orders.forEach((value) {
        //   orderKeys.add(value.data());
        // });
        return ListView.builder(
          // controller: scrollController,
          shrinkWrap: true,
          itemCount: orders.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            // Map requestMap = snapshot.value;

            return Container(
              // height: size.height * 0.285,
              width: double.infinity,
              margin: const EdgeInsets.only(
                top: 20.0,
                bottom: 15.0,
                right: 15.0,
                left: 15.0,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF18171A),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    16.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  // top: size.height * 0.007,
                  left: 6.0,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, top: 18.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(),
                          ),
                          const SizedBox(width: 15),
                          SizedBox(width: size.width * 0.05),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 38.0, right: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Date:\n' + orders[index]['date'],
                            style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: size.height * 0.07,
                          ),
                          Text(
                            'Time:\n' + orders[index]['time'],
                            style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async {
                            // Get.to(ChatScreen(
                            //     userID: requestData['requestedBy']['userID']));
                          },
                          child: Container(
                            height: 40,
                            width: size.width * 0.19,
                            decoration: const BoxDecoration(
                              color: Color(0xFF59C0DA),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  16.0,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(
                                  EvaIcons.messageCircleOutline,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Chat',
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    // });
  }
}
