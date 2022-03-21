import 'package:flutter/material.dart';
import 'package:car_rental/constants/constants.dart';
import 'package:flutter/services.dart';

class LocationCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isPhoneNumber;
  final bool isTransactionPin;

  const LocationCustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isPhoneNumber = false,
    this.isTransactionPin = false,
  }) : super(key: key);

  String? validate(String? value) {
    if (value!.isEmpty) {
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

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (value.length != 10 || !isNumeric(value)) {
      return "Invalid phone number";
    } else {
      return null;
    }
  }

  String? validatePin(String? value) {
    if (value!.isEmpty) {
      return "Required";
    } else if (value.length != 4 || !isNumeric(value)) {
      return "Invalid transaction pin";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: isPhoneNumber
          ? validatePhoneNumber
          : isTransactionPin
              ? validatePin
              : validate,
      cursorColor: Colors.white,
      keyboardType: isPhoneNumber || isTransactionPin
          ? TextInputType.number
          : TextInputType.emailAddress,
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
