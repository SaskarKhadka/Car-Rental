import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/waiting_dialog.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/services/database.dart';
import 'package:car_rental/state/car_state.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/car_details_field.dart';
import '../../constants/constants.dart';

class EditCar extends StatefulWidget {
  static const String id = "/editCar";
  final Map<String, dynamic>? carDetails;
  const EditCar({
    Key? key,
    this.carDetails,
  }) : super(key: key);

  @override
  State<EditCar> createState() => _EditCar();
}

class _EditCar extends State<EditCar> {
  final carTypeController = TextEditingController();
  final carBrandController = TextEditingController();
  final carSeatsController = TextEditingController();
  final carMileageController = TextEditingController();
  final carRateController = TextEditingController();
  final carRegistrationController = TextEditingController();
  late GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    carTypeController.text = widget.carDetails!["type"];
    carBrandController.text = widget.carDetails!["brand"];
    carRateController.text = widget.carDetails!["ratePerDay"];
    carSeatsController.text = widget.carDetails!["numberOfSeats"];
    carMileageController.text = widget.carDetails!["mileage"];
  }

  @override
  void dispose() {
    carTypeController.dispose();
    carBrandController.dispose();
    carRateController.dispose();
    carRegistrationController.dispose();
    carSeatsController.dispose();
    carMileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 70.0, horizontal: 20.0),
          child: Form(
            key: globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // CircleAvatar(
                //   radius: 30,
                // ),
                // SizedBox(
                //   width: 10.0,
                // ),

                const Text(
                  "Edit Car Details",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 30.0,
                ),

                // const Image(
                //   image: AssetImage('images/vector.png'),
                //   height: 230,
                //   width: 230,
                // ),
                CarDetailsCustomTextField(
                    controller: carTypeController,
                    labelText: "Type",
                    icon: EvaIcons.carOutline),
                const SizedBox(
                  height: 20.0,
                ),
                CarDetailsCustomTextField(
                    controller: carBrandController,
                    labelText: "Brand",
                    icon: EvaIcons.carOutline),
                const SizedBox(
                  height: 20.0,
                ),
                CarDetailsCustomTextField(
                    controller: carSeatsController,
                    labelText: "Number of seats",
                    isNum: true,
                    icon: EvaIcons.carOutline),
                const SizedBox(
                  height: 20.0,
                ),
                CarDetailsCustomTextField(
                    controller: carMileageController,
                    labelText: "Mileage",
                    isNum: true,
                    icon: EvaIcons.carOutline),
                const SizedBox(
                  height: 20.0,
                ),
                CarDetailsCustomTextField(
                    controller: carRateController,
                    labelText: "Rate per day",
                    isNum: true,
                    icon: EvaIcons.carOutline),

                const SizedBox(
                  height: 50.0,
                ),

                CustomButton(
                  onPressed: () async {
                    if (globalKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const WaitingDialog(title: "Updating"),
                      );
                      try {
                        await Database.updateCar({
                          "type": carTypeController.text.trim(),
                          "brand": carBrandController.text.trim(),
                          "numberOfSeats": carSeatsController.text.trim(),
                          "mileage": carMileageController.text.trim(),
                          "ratePerDay": carRateController.text.trim(),
                        }, widget.carDetails!["docID"]);
                        navigatorKey.currentState!.pop();
                        navigatorKey.currentState!.pop();
                        getToast(
                            message: "Update successful", color: Colors.green);
                      } on Exception catch (ex) {
                        getToast(
                            message: "Update not successful",
                            color: Colors.red);
                      }
                    }
                  },
                  width: double.infinity,
                  buttonContent: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          EvaIcons.saveOutline,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          "SAVE",
                          style: kButtonContentTextStye,
                        ),
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
