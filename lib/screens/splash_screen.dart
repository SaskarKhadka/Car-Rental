import 'dart:async';
import 'package:car_rental/constants/constants.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/screens/admin/admin_home_page.dart';
import 'package:car_rental/screens/user/tab_pages/home_page.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/screens/user/user_home_page.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String id = '/';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () async {
      // final bool? isAdmin = await Database.isAdmin();
      await navigatorKey.currentState!.pushNamedAndRemoveUntil(
          Authentication.currentUser == null
              ? Signin.id
              : await Database.isAdmin()
                  ? AdminHomePage.id
                  : UserHomePage.id,
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              // height: 50.0,
              height: size.height * 0.3,
            ),
            Container(
              // width: size.width * 0.45,
              color: Colors.black,
              child: Center(
                child: Text(
                  'Car Rental',
                  style: kAppName.copyWith(
                    color: Colors.white,
                    fontSize: 80,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.3,
            ),
          ],
        ),
      ),
    );
  }
}
