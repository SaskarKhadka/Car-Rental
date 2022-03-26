import 'dart:io';
import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/custom_exception.dart';
import 'package:car_rental/components/custom_text_field.dart';
import 'package:car_rental/constants/constants.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/model/user.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/cloudStorage.dart';
import 'package:car_rental/services/database.dart';
import 'package:car_rental/services/google_auth.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(Authentication.userID);
    return Scaffold(
      backgroundColor: Colors.black,
      // backgroundColor: const Color(0xff1B1F2E),
      // backgroundColor: const Color(0xff1C223C),
      // backgroundColor: const Color(0xff22232C),

      body: StreamBuilder<List<User?>>(
          stream: Database.getUser(Authentication.userID),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              print(snapshot.data);
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.white60,
                  ),
                ],
              );
            }
            print(snapshot.data);
            User? user = snapshot.data![0];

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 20.0,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 70.0,
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            final imgPicker = ImagePicker();
                            final pickedFile = await imgPicker.pickImage(
                                source: ImageSource.gallery);

                            File? file = File(pickedFile!.path);

                            if (!(await file.exists())) {
                              return;
                            }
                            File? croppedFile = await ImageCropper().cropImage(
                                sourcePath: pickedFile.path,
                                aspectRatioPresets: [
                                  CropAspectRatioPreset.original,
                                  CropAspectRatioPreset.ratio16x9,
                                  CropAspectRatioPreset.ratio3x2,
                                  CropAspectRatioPreset.square,
                                  CropAspectRatioPreset.ratio4x3,
                                ]);

                            if (croppedFile == null) return;

                            bool uploaded =
                                await CloudStorage.uploadProfilePicture(
                                    croppedFile);

                            if (uploaded) {
                              getToast(
                                  message: 'Your Profile Picture was updated',
                                  color: Colors.green);
                            } else {
                              getToast(
                                  message:
                                      'Your Profile Picture could not be updated',
                                  color: Colors.red);
                            }
                          } catch (e) {
                            print(e);
                            // colourController.changeColour(Colors.white54);
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Image.network(user!.profileUrl,
                              fit: BoxFit.fill, height: 140, width: 140,
                              loadingBuilder: (_, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return CircularProgressIndicator(
                              color: Colors.black,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            );
                            // imageUrl: this.strImageURL,
                          } // placeholder: new CircularProgressIndicator(),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35.0,
                    ),
                    CustomButton(
                      onPressed: () {},
                      borderRadius: 20.0,
                      width: double.infinity,
                      // buttonColor: const Color(0xffEEC776),
                      buttonColor: Colors.white,
                      buttonContent: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              EvaIcons.personOutline,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              user.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Flexible(
                      child: CustomButton(
                        borderRadius: 20.0,
                        onPressed: () {},
                        // buttonColor: const Color(0xff8AC186),
                        buttonColor: Colors.white,
                        width: double.infinity,
                        buttonContent: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                EvaIcons.emailOutline,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Flexible(
                                child: Text(
                                  user.email,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Montserrat",
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    CustomButton(
                      borderRadius: 20.0,
                      width: double.infinity,
                      onPressed: () {
                        // user.phoneNumber == "Phone Number"
                        //     ?
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Please enter your phone number",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    CustomTextField(
                                      controller: phoneNumberController,
                                      labelText: "Phone Number",
                                      icon: EvaIcons.phoneCallOutline,
                                      isPhoneNumber: true,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      height: 30.0,
                                    ),
                                    CustomButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                CircularProgressIndicator(
                                                  color: Colors.white,
                                                  backgroundColor: Colors.black,
                                                ),
                                              ],
                                            ),
                                          );
                                          try {
                                            await Database.updatePhoneNumber(
                                                phoneNumberController.text
                                                    .trim());
                                            navigatorKey.currentState!.pop();
                                            navigatorKey.currentState!.pop();
                                            getToast(
                                              message:
                                                  "Your phone number was updated",
                                              color: Colors.green,
                                            );
                                          } on CustomException catch (ex) {
                                            navigatorKey.currentState!.pop();
                                            navigatorKey.currentState!.pop();
                                            getToast(
                                              message:
                                                  "Phone Number couldnot be updated",
                                              color: Colors.red,
                                            );
                                          }
                                        }
                                      },
                                      width: double.infinity,
                                      buttonColor: Colors.black,
                                      buttonContent: const Text(
                                        "PROCEED",
                                        style: kButtonContentTextStye,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                        // : null;
                      },
                      // buttonColor: const Color(0xff8969F8),
                      // buttonColor: const Color(0xff8AC186),
                      // buttonColor: const Color(0xff7767D8),
                      // buttonColor: const Color(0xffFFABC7),
                      buttonColor: Colors.white,

                      buttonContent: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              EvaIcons.phoneCallOutline,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              user.phoneNumber,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 25.0,
                      ),
                      // width: MediaQuery.of(context).size.width * 0.35,
                      // height: 50.0,
                      decoration: BoxDecoration(
                        color: const Color(0xff8969F8),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white30,
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                            // offset: Offset(7, 7),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            await GoogleAuthentication.signOut();
                            await Authentication.signOut();
                            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                                Signin.id, (route) => false);
                          } on PlatformException catch (ex) {
                            await Authentication.signOut();
                            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                                Signin.id, (route) => false);
                          } on CustomException catch (ex) {
                            getToast(
                              message: "Couldnot sign out",
                              color: Colors.red,
                            );
                          }
                        },
                        child: const Text(
                          "Sign Out",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
