import 'package:car_rental/components/waiting_dialog.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/screens/admin/admin_home_page.dart';
import 'package:car_rental/screens/user/tab_pages/home_page.dart';
import 'package:car_rental/screens/user/user_home_page.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:flutter/material.dart';
import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/custom_password_field.dart';
import 'package:car_rental/components/custom_text_field.dart';
import 'package:car_rental/components/scroll_behaviour.dart';
import 'package:car_rental/constants/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:car_rental/screens/signup_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signin extends StatefulWidget {
  static const String id = "/signin";
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  late TextEditingController emailController;

  late TextEditingController passwordController;

  late TextEditingController websiteController;

  late GlobalKey<FormState> globalKey;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    websiteController = TextEditingController();
    globalKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Scaffold(
        // backgroundColor: Color(0xff264653),
        // backgroundColor: const Color(0xff2ECC71),

        backgroundColor: Colors.white,
        // backgroundColor: const Color(0xff33CEA2),
        body: Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.1,
            left: 25.0,
            right: 25.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "EV  Rental",
                style: kAppName.copyWith(
                  fontSize: 100,
                  // fontFamily: "Bungee",
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Expanded(
                  child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 50.0,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "LOG IN",
                          textAlign: TextAlign.center,
                          style: kTextFieldLabelStyle.copyWith(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: globalKey,
                          // autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                controller: emailController,
                                labelText: "EMAIL",
                                icon: EvaIcons.emailOutline,
                                isEmail: true,
                              ),
                              SizedBox(
                                height: size.height * 0.035,
                              ),
                              CustomPasswordField(
                                controller: passwordController,
                                labelText: "PASSWORD",
                                icon: EvaIcons.lockOutline,
                              ),
                              SizedBox(
                                height: size.height * 0.09,
                              ),
                              CustomButton(
                                onPressed: () async {
                                  if (globalKey.currentState!.validate()) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const WaitingDialog(
                                          title: "Authenticating"),
                                    );
                                    try {
                                      await Authentication.signIn(
                                          email: emailController.text.trim(),
                                          password: passwordController.text);
                                      final bool isAdmin =
                                          await Database.isAdmin();
                                      navigatorKey.currentState!.pop();
                                      navigatorKey.currentState!.pushNamed(
                                          isAdmin
                                              ? AdminHomePage.id
                                              : UserHomePage.id);
                                      getToast(
                                          message: "Login successful",
                                          color: Colors.green);
                                    } on Exception catch (ex) {
                                      navigatorKey.currentState!.pop();
                                      getToast(
                                          message:
                                              "Invalid username or passowrd",
                                          color: Colors.red);
                                      print(ex.toString().split(". ")[0] + ".");
                                    }
                                  }
                                },
                                buttonContent: const Text(
                                  "LOG IN",
                                  style: kButtonContentTextStye,
                                ),
                                width: size.width * 0.75,
                                // buttonColor: const Color(0xff2ECC71),
                              ),
                              //   ],
                              // ),
                              const SizedBox(
                                height: 70.0,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account ?  ',
                              style: kTextFieldLabelStyle.copyWith(
                                fontSize: 16.0,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                navigatorKey.currentState!.pushNamed(Signup.id);
                              },
                              child: Text(
                                'Register',
                                style: kTextFieldLabelStyle.copyWith(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

getToast({String? message, Color? color}) {
  Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}
