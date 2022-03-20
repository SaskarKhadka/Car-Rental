import 'package:flutter/material.dart';
import 'package:car_rental/constants/constants.dart';

class LocationCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;

  const LocationCustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
  }) : super(key: key);

  String? validate(String? value) {
    if (value!.isEmpty) {
      return "Required";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validate,
      cursorColor: Colors.white,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            icon,
            color: const Color(0xffaaabac),
          ),
        ),
        label: Text(
          labelText,
        ),
        labelStyle: kTextFieldLabelStyle.copyWith(
          color: const Color(0xffaaabac),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffaaabac)),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffaaabac)),
        ),
      ),
      style: kTextFieldTextStyle.copyWith(color: Colors.white),
    );
  }
}
