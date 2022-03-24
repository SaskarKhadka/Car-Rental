import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/main.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String profileUrl;

  const ProfileDialog({
    Key? key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileUrl,
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
              color: const Color(0xff1B1F2E),
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
                ),
                const SizedBox(
                  height: 25.0,
                ),
                boxedItem(
                  EvaIcons.emailOutline,
                  email,
                  const Color(0xff8AC186),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                boxedItem(
                  EvaIcons.phoneCallOutline,
                  phoneNumber,
                  const Color(0xffFFABC7),
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

  boxedItem(IconData? icon, String? text, Color? color) {
    return Container(
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
    );
  }
}
