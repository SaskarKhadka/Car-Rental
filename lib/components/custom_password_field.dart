import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_rental/constants/constants.dart';
import 'package:car_rental/state/password_eye.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;

  const CustomPasswordField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
  }) : super(key: key);

  String? validatePassword(String? password) {
    if (password!.isEmpty) {
      return "Required";
    } else if (password.length < 8) {
      return "Must be at least 8 characters";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordEyeState>(builder: (context, eyeState, _) {
      return TextFormField(
        controller: controller,
        validator: validatePassword,
        cursorColor: Colors.black,
        keyboardType: TextInputType.emailAddress,
        obscureText:
            Provider.of<PasswordEyeState>(context, listen: false).seePassword,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              icon,
              color: Colors.black,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              Provider.of<PasswordEyeState>(context, listen: false)
                  .changeState();
            },
            child: eyeState.seePassword
                ? const Icon(
                    EvaIcons.eyeOff,
                    color: Colors.black,
                  )
                : const Icon(
                    EvaIcons.eye,
                    color: Colors.black,
                  ),
          ),
          label: Text(
            labelText,
          ),
          labelStyle: kTextFieldLabelStyle,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        style: kTextFieldTextStyle,
      );
    });
  }
}
