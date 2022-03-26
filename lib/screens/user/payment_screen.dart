import 'dart:io';

import 'package:car_rental/components/continue_dialog.dart';
import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/custom_text_field.dart';
import 'package:car_rental/components/location_field.dart';
import 'package:car_rental/components/waiting_dialog.dart';
import 'package:car_rental/constants/constants.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';

class Payment extends StatefulWidget {
  static const String id = "/payment";
  final Map<String, dynamic>? args;
  const Payment({Key? key, this.args}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final phoneNumberController = TextEditingController();
  final transactionPinController = TextEditingController();
  final amountController = TextEditingController();
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    amountController.text = widget.args!["amount"];
    super.initState();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    transactionPinController.dispose();
    amountController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 25.0,
            right: 25.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                Image.asset("images/khalti.png"),
                const SizedBox(
                  height: 15.0,
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: amountController,
                          labelText: "Amount",
                          icon: Icons.payment_outlined,
                          isAmount: true,
                          color: const Color(0xff4C276C),
                          canBeEdited: false,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        CustomTextField(
                          controller: phoneNumberController,
                          labelText: "Phone Number",
                          icon: EvaIcons.phoneCallOutline,
                          isPhoneNumber: true,
                          color: const Color(0xff4C276C),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        CustomTextField(
                          controller: transactionPinController,
                          labelText: "Transaction Pin",
                          icon: EvaIcons.lockOutline,
                          isTransactionPin: true,
                          color: const Color(0xff4C276C),
                        ),
                        const SizedBox(
                          height: 70.0,
                        ),
                        CustomButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                builder: (context) => const WaitingDialog(
                                  title: "Processing",
                                  borderColor: Color(0xff4C276C),
                                  progressIndicatorColor: Color(0xff4C276C),
                                  textColor: Color(0xff4C276C),
                                ),
                              );

                              await Khalti.init(
                                publicKey:
                                    "test_public_key_76063d06952d4cc48cee6fd516fe41b8",
                                enabledDebugging: false,
                              );
                              late PaymentInitiationResponseModel
                                  initiationModel;
                              try {
                                initiationModel =
                                    await Khalti.service.initiatePayment(
                                  request: PaymentInitiationRequestModel(
                                    // amount:
                                    //     int.parse(amountController.text * 100),
                                    amount: 1000,
                                    mobile: phoneNumberController.text.trim(),
                                    transactionPin:
                                        transactionPinController.text.trim(),
                                    // mobile: "9818897782",
                                    productIdentity: widget.args!["car"],
                                    productName: "Car",
                                  ),
                                );
                              } on FailureHttpResponse catch (ex) {
                                navigatorKey.currentState!.pop();
                                Map<String, dynamic>? exceptionData =
                                    ex.data as Map<String, dynamic>;
                                return getToast(
                                  message:
                                      exceptionData["tries_remaining"] == null
                                          ? exceptionData["detail"]
                                              .toString()
                                              .split(". ")[0]
                                          : exceptionData["detail"]
                                                  .toString()
                                                  .split(". ")[0] +
                                              " Tries Remaining: " +
                                              exceptionData["tries_remaining"],
                                  color: Colors.red,
                                );
                              }

                              navigatorKey.currentState!.pop();
                              await showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Please enter the OTP you just received.",
                                          style: TextStyle(
                                            color: Color(0xff4C276C),
                                            // fontFamily: "Montserrat",
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        CustomTextField(
                                          controller: otpController,
                                          labelText: "OTP",
                                          icon: EvaIcons.lockOutline,
                                          color: const Color(0xff4C276C),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        CustomButton(
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  CircularProgressIndicator(
                                                    color: Colors.white,
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                ],
                                              ),
                                            );
                                            try {
                                              final confirmationModel =
                                                  await Khalti.service
                                                      .confirmPayment(
                                                request:
                                                    PaymentConfirmationRequestModel(
                                                  confirmationCode: otpController
                                                      .text
                                                      .trim(), // the OTP code received through previous step
                                                  token: initiationModel.token,
                                                  transactionPin:
                                                      transactionPinController
                                                          .text
                                                          .trim(),
                                                ),
                                              );

                                              //TODO: delete order;
                                              await Database
                                                  .orderCompleteTransaction(
                                                widget.args!["orderID"],
                                                widget.args!["car"],
                                              );

                                              navigatorKey.currentState!.pop();
                                              navigatorKey.currentState!.pop();
                                              navigatorKey.currentState!.pop();
                                              getToast(
                                                message:
                                                    "Transaction Successful.",
                                                color: Colors.green,
                                              );
                                              print(confirmationModel.amount);
                                            } on FailureHttpResponse catch (ex) {
                                              navigatorKey.currentState!.pop();
                                              print(ex.message);
                                              getToast(
                                                message:
                                                    "OTP code doesnot match",
                                                color: Colors.red,
                                              );
                                            }
                                          },
                                          width: double.infinity,
                                          buttonColor: const Color(0xff4C276C),
                                          buttonContent: const Text(
                                            "PROCEED",
                                            style: kButtonContentTextStye,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          width: double.infinity,
                          buttonContent: const Text(
                            "CONFIRM",
                            style: kButtonContentTextStye,
                          ),
                          buttonColor: const Color(0xff4C276C),
                          // ElevatedButton(
                          //   onPressed: () async {
                          // await Khalti.init(
                          //   publicKey:
                          //       "test_public_key_76063d06952d4cc48cee6fd516fe41b8",
                          //   enabledDebugging: false,
                          // );
                          // // KhaltiService.publicKey =
                          // //     "test_public_key_76063d06952d4cc48cee6fd516fe41b8";
                          // // final service = KhaltiService(client: KhaltiHttpClient());
                          // final initiationModel =
                          //     await Khalti.service.initiatePayment(
                          //   request: PaymentInitiationRequestModel(
                          //     amount: 1000, // in paisa
                          //     mobile: phoneNumberController.text.trim(),
                          //     transactionPin: transactionPinController.text.trim(),
                          //     // mobile: "9818897782",
                          //     productIdentity: 'mac-mini',
                          //     productName: 'Apple Mac Mini',
                          //     productUrl:
                          //         'https://khalti.com/bazaar/mac-mini-16-512-m1',
                          //     additionalData: {
                          //       'vendor': 'Oliz Store',
                          //       'manufacturer': 'Apple Inc.',
                          //     },
                          //   ),
                          // );
                          // print(initiationModel.token);
                          // print(initiationModel.pinCreated);
                          // String? otp;
                          // await showDialog(
                          //   context: context,
                          //   builder: (context) => Dialog(
                          //     child: Container(
                          //       padding: const EdgeInsets.all(20.0),
                          //       height: 300,
                          //       child: Column(
                          //         children: [
                          //           CustomTextField(
                          //             controller: otpController,
                          //             labelText: "OTP",
                          //             icon: EvaIcons.lockOutline,
                          //           ),
                          //           const SizedBox(
                          //             height: 20.0,
                          //           ),
                          //           ElevatedButton(
                          //               onPressed: () {
                          //                 otp = otpController.text.trim();
                          //                 navigatorKey.currentState!.pop();
                          //               },
                          //               child: Text("COnfirm")),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // );
                          // try {
                          //   final confirmationModel =
                          //       await Khalti.service.confirmPayment(
                          //     request: PaymentConfirmationRequestModel(
                          //       confirmationCode:
                          //           otp!, // the OTP code received through previous step
                          //       token: initiationModel.token,
                          //       transactionPin: "1024",
                          //     ),
                          //   );
                          //   print(confirmationModel.amount);
                          // } on Exception catch (ex) {
                          //   print(ex.toString());
                          // }
                          //   },
                          //   child: const Text("Pay 10 rs"),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
