import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/state/card_index_date.dart';
import 'package:car_rental/state/image_index_state.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDialog extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String profileUrl;
  final List citizenship;
  final List lisence;

  const ProfileDialog({
    Key? key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileUrl,
    required this.citizenship,
    required this.lisence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      // elevation: 10.0,
      // backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size.width,
            padding: const EdgeInsets.only(
              top: 15.0,
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
            ),
            decoration: BoxDecoration(
              // color: const Color(0xff1B1F2E),
              color: Colors.black,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white30,
                  offset: Offset(0, 2),
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 60.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.network(profileUrl,
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
                const SizedBox(
                  height: 25.0,
                ),
                boxedItem(
                  EvaIcons.personOutline,
                  name,
                  const Color(0xffEEC776),
                  () {},
                ),
                const SizedBox(
                  height: 25.0,
                ),
                boxedItem(
                  EvaIcons.emailOutline,
                  email,
                  const Color(0xff8AC186),
                  () {},
                ),
                const SizedBox(
                  height: 25.0,
                ),
                boxedItem(
                  EvaIcons.phoneCallOutline,
                  phoneNumber,
                  const Color(0xffFFABC7),
                  () {},
                ),
                const SizedBox(
                  height: 25.0,
                ),
                boxedItem(
                  Icons.document_scanner_outlined,
                  "Citizenship",
                  Colors.cyan,
                  () async {
                    citizenship.isEmpty
                        ? getToast(
                            message:
                                "The user has not provided citizenship pictures",
                            color: Colors.red,
                          )
                        : showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              // backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Provider.of<CardIndexState>(context,
                                                    listen: false)
                                                .changeState(-1);
                                          },
                                          child: const Icon(
                                            EvaIcons.arrowBackOutline,
                                          ),
                                        ),
                                        Image.network(
                                          citizenship[
                                              Provider.of<CardIndexState>(
                                                      context,
                                                      listen: true)
                                                  .imageIndex!],
                                          height: 200.0,
                                          width: 200.0,
                                          fit: BoxFit.fill,
                                          loadingBuilder:
                                              (_, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 30.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  CircularProgressIndicator(
                                                    color: Colors.black,
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Provider.of<CardIndexState>(
                                                      context,
                                                      listen: false)
                                                  .changeState(1);
                                            },
                                            child: const Icon(
                                                EvaIcons.arrowForwardOutline)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                  },
                ),
                const SizedBox(
                  height: 25.0,
                ),
                boxedItem(
                  Icons.document_scanner_outlined,
                  "Lisence",
                  Colors.blue,
                  () async {
                    lisence.isEmpty
                        ? getToast(
                            message:
                                "The user has not provided lisence pictures",
                            color: Colors.red,
                          )
                        : showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              // backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Provider.of<CardIndexState>(context,
                                                    listen: false)
                                                .changeState(-1);
                                          },
                                          child: const Icon(
                                            EvaIcons.arrowBackOutline,
                                          ),
                                        ),
                                        Image.network(
                                          lisence[Provider.of<CardIndexState>(
                                                  context,
                                                  listen: true)
                                              .imageIndex!],
                                          height: 200.0,
                                          width: 200.0,
                                          fit: BoxFit.fill,
                                          loadingBuilder:
                                              (_, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 30.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  CircularProgressIndicator(
                                                    color: Colors.black,
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Provider.of<CardIndexState>(
                                                      context,
                                                      listen: false)
                                                  .changeState(1);
                                            },
                                            child: const Icon(
                                                EvaIcons.arrowForwardOutline)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                  },
                ),
                SizedBox(
                  height: size.height * 0.035,
                ),
                GestureDetector(
                  onTap: () {
                    navigatorKey.currentState!.pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5962DA),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.white,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  boxedItem(IconData? icon, String? text, Color? color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(5, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon!,
              color: Colors.black,
              size: 22.0,
            ),
            const SizedBox(
              width: 15.0,
            ),
            Flexible(
              child: Text(
                text!,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
