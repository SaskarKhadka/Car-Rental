import 'package:car_rental/main.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class UserHistory extends StatelessWidget {
  const UserHistory({Key? key}) : super(key: key);

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
              'My History',
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
                              fontFamily: "Montserrat",
                              color: Colors.black,
                              letterSpacing: 1.8,
                            ),
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
          child: UserHistoryStream(),
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

class UserHistoryStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container();
  }
}
