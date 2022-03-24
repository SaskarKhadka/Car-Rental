import 'dart:io';
import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/custom_exception.dart';
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

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      backgroundColor: const Color(0xff1B1F2E),
      // backgroundColor: const Color(0xff1C223C),
      // backgroundColor: const Color(0xff22232C),

      body: StreamBuilder<List<User?>>(
          stream: Database.getUser(Authentication.userID),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.white60,
                  ),
                ],
              );
            }
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
                                await CloudStorage.uploadFile(croppedFile);

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
                      buttonColor: const Color(0xffEEC776),
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
                        buttonColor: const Color(0xff8AC186),
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
                      onPressed: () {},
                      // buttonColor: const Color(0xff8969F8),
                      // buttonColor: const Color(0xff8AC186),
                      // buttonColor: const Color(0xff7767D8),
                      buttonColor: const Color(0xffFFABC7),
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
                    // const SizedBox(
                    //   width: 15.0,
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //     vertical: 15.0,
                    //     horizontal: 20.0,
                    //   ),
                    //   width: MediaQuery.of(context).size.width * 0.35,
                    //   // height: 50.0,
                    //   decoration: BoxDecoration(
                    //     color: const Color(0xff8969F8),
                    //     borderRadius: BorderRadius.circular(15.0),
                    //   ),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       try {
                    //         await GoogleAuthentication.signOut();
                    //         await Authentication.signOut();
                    //         navigatorKey.currentState!
                    //             .pushNamedAndRemoveUntil(
                    //                 Signin.id, (route) => false);
                    //       } on PlatformException catch (ex) {
                    //         await Authentication.signOut();
                    //         navigatorKey.currentState!
                    //             .pushNamedAndRemoveUntil(
                    //                 Signin.id, (route) => false);
                    //       } on CustomException catch (ex) {
                    //         print(ex);
                    //       }
                    //     },
                    //     child: const Text(
                    //       "Sign Out",
                    //       style: TextStyle(
                    //         color: Colors.black,
                    //         fontFamily: "Montserrat",
                    //         fontSize: 20.0,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // ],
                    // ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
