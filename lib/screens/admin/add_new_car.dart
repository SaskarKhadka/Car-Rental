import 'dart:io';

import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/waiting_dialog.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/services/cloudStorage.dart';
import 'package:car_rental/services/database.dart';
import 'package:car_rental/state/car_pics_state.dart';
import 'package:car_rental/state/car_state.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../components/car_details_field.dart';
import '../../constants/constants.dart';

class AddNewCar extends StatefulWidget {
  static const String id = "/addNewCar";
  const AddNewCar({Key? key}) : super(key: key);

  @override
  State<AddNewCar> createState() => _AddNewCarState();
}

class _AddNewCarState extends State<AddNewCar> {
  late TextEditingController? carTypeController;
  late TextEditingController? carBrandController;
  TextEditingController? carSeatsController;
  TextEditingController? carMileageController;
  TextEditingController? carRateController;
  TextEditingController? carRegistrationController;
  late GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    carTypeController = TextEditingController();
    carBrandController = TextEditingController();
    carSeatsController = TextEditingController();
    carMileageController = TextEditingController();
    carRegistrationController = TextEditingController();
    carRateController = TextEditingController();
  }

  @override
  void dispose() {
    carTypeController!.dispose();
    carBrandController!.dispose();
    carRateController!.dispose();
    carRegistrationController!.dispose();
    carSeatsController!.dispose();
    carMileageController!.dispose();
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
                  "Car Details",
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
                    controller: carTypeController!,
                    labelText: "Type",
                    icon: EvaIcons.carOutline),
                const SizedBox(
                  height: 20.0,
                ),
                CarDetailsCustomTextField(
                    controller: carBrandController!,
                    labelText: "Brand",
                    icon: EvaIcons.carOutline),
                const SizedBox(
                  height: 20.0,
                ),
                CarDetailsCustomTextField(
                    controller: carSeatsController!,
                    labelText: "Number of seats",
                    isNum: true,
                    icon: EvaIcons.carOutline),
                const SizedBox(
                  height: 20.0,
                ),
                CarDetailsCustomTextField(
                    controller: carMileageController!,
                    labelText: "Mileage",
                    isNum: true,
                    icon: EvaIcons.carOutline),
                const SizedBox(
                  height: 20.0,
                ),
                CarDetailsCustomTextField(
                    controller: carRateController!,
                    labelText: "Rate per day",
                    isNum: true,
                    icon: EvaIcons.carOutline),
                const SizedBox(
                  height: 20.0,
                ),
                CarDetailsCustomTextField(
                    controller: carRegistrationController!,
                    labelText: "Registration Number",
                    icon: EvaIcons.carOutline),
                const SizedBox(
                  height: 30.0,
                ),
                CustomButton(
                  onPressed: () async {
                    try {
                      final imgPicker = ImagePicker();
                      final pickedFiles = await imgPicker.pickMultiImage();

                      if (pickedFiles!.isEmpty) return;

                      Provider.of<CarPicsState>(context, listen: false)
                          .changeState(pickedFiles);
                    } catch (e) {
                      print(e);
                      // colourController.changeColour(Colors.white54);
                    }
                  },
                  width: double.infinity,
                  buttonContent: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          EvaIcons.uploadOutline,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          "UPLOAD PICS",
                          style: kButtonContentTextStye,
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                CustomButton(
                  onPressed: () async {
                    if (globalKey.currentState!.validate()) {
                      final files =
                          Provider.of<CarPicsState>(context, listen: false)
                              .carPics;
                      if (files.isEmpty) {
                        return getToast(
                          message: "No pictures are slected",
                          color: Colors.red,
                        );
                      }

                      showDialog(
                        context: context,
                        builder: (context) =>
                            const WaitingDialog(title: "Updating"),
                      );

                      try {
                        List<String> picsUrl = [];
                        for (final xfile in files) {
                          File? file = File(xfile!.path);
                          String? url = await CloudStorage.uploadCarPic(
                            file,
                            carRegistrationController!.text.trim(),
                          );
                          picsUrl.add(url);
                        }
                        final coverPicUrl = picsUrl.removeAt(0);
                        await Database.saveCar({
                          "type": carTypeController!.text.trim(),
                          "brand": carBrandController!.text.trim(),
                          "numberOfSeats": carSeatsController!.text.trim(),
                          "mileage": carMileageController!.text.trim(),
                          "ratePerDay": carRateController!.text.trim(),
                          "registrationNumber":
                              carRegistrationController!.text.trim(),
                          "coverPicUrl": coverPicUrl,
                          "picsUrl": picsUrl,
                        });
                        navigatorKey.currentState!.pop();
                        navigatorKey.currentState!.pop();
                        getToast(
                          message: "New car added",
                          color: Colors.green,
                        );
                      } on Exception catch (ex) {
                        navigatorKey.currentState!.pop();
                        getToast(
                          message: "Car couldnot be added",
                          color: Colors.red,
                        );
                        print(ex.toString().split(". ")[0] + ".");
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
