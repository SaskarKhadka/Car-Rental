import 'package:car_rental/screens/admin/add_new_car.dart';
import 'package:car_rental/screens/admin/admin_home_page.dart';
import 'package:car_rental/screens/admin/edit_car.dart';
import 'package:car_rental/screens/user/available_cars.dart';
import 'package:car_rental/screens/user/payment_screen.dart';
import 'package:car_rental/screens/user/tab_pages/home_page.dart';
import 'package:car_rental/screens/splash_screen.dart';
import 'package:car_rental/screens/user/tab_pages/user_history.dart';
import 'package:car_rental/screens/user/user_home_page.dart';
import 'package:car_rental/state/car_state.dart';
import 'package:car_rental/state/date_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/screens/signup_screen.dart';
import 'package:car_rental/state/password_eye.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CarRental());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CarRental extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PasswordEyeState()),
        ChangeNotifierProvider(create: (context) => CarState()),
        ChangeNotifierProvider(create: (context) => DateState()),
      ],
      builder: (context, _) => MaterialApp(
        title: 'car_rental',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Signin.id,
        navigatorKey: navigatorKey,
        routes: {
          SplashScreen.id: (context) => const SplashScreen(),
          Signin.id: (context) => const Signin(),
          Signup.id: (context) => const Signup(),
          AdminHomePage.id: (context) => AdminHomePage(),
          AddNewCar.id: (context) => const AddNewCar(),
          EditCar.id: (context) => EditCar(
              carDetails: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>),
          UserHomePage.id: (context) => const UserHomePage(),
          AvailableCars.id: (context) => AvailableCars(
              args: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>),
          Payment.id: (context) => Payment(
              args: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>),
        },
      ),
    );
  }
}