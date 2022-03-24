import 'package:car_rental/components/waiting_dialog.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/screens/user/tab_pages/home_page.dart';
import 'package:car_rental/screens/user/user_home_page.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/custom_password_field.dart';
import 'package:car_rental/components/custom_text_field.dart';
import 'package:car_rental/components/scroll_behaviour.dart';
import 'package:car_rental/constants/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:car_rental/screens/signin_screen.dart';

class Signup extends StatefulWidget {
  static const String id = "/signup";
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneNumberController;
  late GlobalKey<FormState> globalKey;

  @override
  void initState() {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNumberController = TextEditingController();
    globalKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Scaffold(
        // backgroundColor: const Color(0xff264653),
        // backgroundColor: const Color(0xff2ECC71),
        // backgroundColor: const Color(0xff201A31),
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
                "EV Rental",
                style: kAppName.copyWith(
                  fontSize: 50,
                  fontFamily: "Bungee",
                ),
              ),
              // SizedBox(
              //   height: size.height * 0.01,
              // ),
              Expanded(
                  child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 40.0,
                      bottom: 50.0,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "CREATE NEW ACCOUNT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Form(
                          key: globalKey,
                          // autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                controller: usernameController,
                                labelText: "USERNAME",
                                icon: EvaIcons.personOutline,
                              ),
                              SizedBox(
                                height: size.height * 0.035,
                              ),
                              CustomTextField(
                                controller: phoneNumberController,
                                labelText: "PHONE NUMBER",
                                icon: EvaIcons.phoneCallOutline,
                                isPhoneNumber: true,
                              ),
                              SizedBox(
                                height: size.height * 0.035,
                              ),
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
                                height: size.height * 0.07,
                              ),
                              CustomButton(
                                onPressed: () async {
                                  if (globalKey.currentState!.validate()) {
                                    //TODO: write validation for phone number
                                    showDialog(
                                      context: context,
                                      builder: (context) => const WaitingDialog(
                                          title: "Authenticating"),
                                    );
                                    try {
                                      await Authentication.signUp(
                                        userData: {
                                          "name":
                                              usernameController.text.trim(),
                                          "email": emailController.text.trim(),
                                          "phoneNumber":
                                              phoneNumberController.text.trim(),
                                        },
                                        password: passwordController.text,
                                      );
                                      navigatorKey.currentState!.pop();
                                      navigatorKey.currentState!
                                          .pushNamed(UserHomePage.id);
                                      getToast(
                                          message:
                                              "Account created successfully",
                                          color: Colors.green);
                                    } on Exception catch (ex) {
                                      navigatorKey.currentState!.pop();
                                      getToast(
                                          message: "Account already exists",
                                          color: Colors.red);
                                      print(ex.toString());
                                    }
                                  }
                                },
                                buttonContent: const Text(
                                  "REGISTER",
                                  style: kButtonContentTextStye,
                                ),
                                width: size.width * 0.75,
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Already have an account ?  ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        navigatorKey.currentState!
                                            .pushNamed(Signin.id);
                                      },
                                      child: const Text(
                                        'Log In',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
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
