import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:car_rental/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isEmail;
  final bool isPhoneNumber;
  final bool isTransactionPin;
  final Color color;
  final bool isAmount;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isEmail = false,
    this.isPhoneNumber = false,
    this.isTransactionPin = false,
    this.color = Colors.black,
    this.isAmount = false,
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

  String? validatePhoneNumber(String? value) {
    if (value!.trim().isEmpty) {
      return "Required";
    } else if (value.trim().length != 10 || !isNumeric(value.trim())) {
      return "Invalid phone number";
    } else {
      return null;
    }
  }

  String? validatePin(String? value) {
    if (value!.trim().isEmpty) {
      return "Required";
    } else if (value.trim().length != 4 || !isNumeric(value.trim())) {
      return "Invalid transaction pin";
    } else {
      return null;
    }
  }

  String? validateAmount(String? value) {
    if (value!.trim().isEmpty) {
      return "Required";
    } else if (!isNumeric(value.trim())) {
      return "Invalid Amount";
    } else {
      return null;
    }
  }

  String? validateEmail(String? email) {
    if (email!.trim().isEmpty) {
      return "Required";
    } else if (!RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email.trim())) {
      return "Email not valid";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: isEmail
          ? validateEmail
          : isPhoneNumber
              ? validatePhoneNumber
              : isTransactionPin
                  ? validatePin
                  : isAmount
                      ? validateAmount
                      : validate,
      cursorColor: color,
      keyboardType: isPhoneNumber || isTransactionPin || isAmount
          ? TextInputType.number
          : TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        label: Text(
          labelText,
        ),
        labelStyle: kTextFieldLabelStyle.copyWith(
          color: color,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
      ),
      style: kTextFieldTextStyle,
    );
  }
}
