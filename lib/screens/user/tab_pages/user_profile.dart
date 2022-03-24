import 'package:car_rental/components/custom_exception.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/google_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
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
                print(ex);
              }
            },
            child: const Text("Sign Out")),
      ),
    );
  }
}
