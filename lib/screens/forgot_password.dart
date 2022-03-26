import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/custom_exception.dart';
import 'package:car_rental/components/custom_text_field.dart';
import 'package:car_rental/components/waiting_dialog.dart';
import 'package:car_rental/constants/constants.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgotPassword';

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final textController = Get.find<TextController>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                Text(
                  "EV  Rental",
                  style: kAppName.copyWith(
                    fontSize: 40,
                    fontFamily: "Bungee",
                  ),
                ),
                SizedBox(
                    height: size.height * 0.25,
                    child: Center(
                        child: Image.asset('images/forgetpassword.png'))),
                const Text(
                  'Reset Password !',
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                const Text(
                  'Please Enter Your Email Address To',
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "Montserrat",
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                const Text(
                  'Recieve a Verification Code ',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontFamily: "Montserrat",
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                CustomTextField(
                  controller: emailController,
                  labelText: 'EMAIL',
                  icon: EvaIcons.personOutline,
                  isEmail: true,
                ),
                SizedBox(height: size.height * 0.09),
                CustomButton(
                  buttonContent: Text(
                    "CONFIRM",
                    style: kButtonContentTextStye.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  width: double.infinity,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) => const WaitingDialog(
                          title: 'Processing',
                        ),
                      );
                      try {
                        await Authentication.passwordReset(
                          email: emailController.text.trim(),
                        );
                      } on CustomException catch (ex) {
                        return getToast(
                          message: "User not found",
                          color: Colors.red,
                        );
                      }
                      emailController.clear();
                      navigatorKey.currentState!.pop();
                      getToast(
                        message: "Password link sent to the email",
                        color: Colors.green,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
