import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:car_rental/constants/constants.dart';

class CarDetailsCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isNum;

  const CarDetailsCustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isNum = false,
  }) : super(key: key);

  String? validate(String? username) {
    if (username!.trim().isEmpty) {
      return "Required";
    } else {
      return null;
    }
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  String? validateSeatsAndRate(String? value) {
    if (value!.trim().isEmpty) {
      return "Required";
    } else if (isNumeric(value.trim())) {
      return null;
    } else {
      return "Invalid value";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: isNum ? validateSeatsAndRate : validate,
      cursorColor: Colors.black,
      keyboardType: isNum ? TextInputType.number : TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            icon,
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
  }
}
