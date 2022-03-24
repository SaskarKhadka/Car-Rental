import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final Widget buttonContent;
  final Color buttonColor;
  final bool border;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.width,
    required this.buttonContent,
    this.buttonColor = const Color(0xff181E23),
    this.border = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: size.height * 0.07,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30.0),
          border: border ? Border.all(color: Colors.blue[400]!) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(5, 10),
            ),
          ],
        ),
        child: Center(
          child: buttonContent,
        ),
      ),
    );
  }
}

class CustomButtonGray extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final Widget buttonContent;

  const CustomButtonGray({
    Key? key,
    required this.onPressed,
    required this.width,
    required this.buttonContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: size.height * 0.07,
        decoration: BoxDecoration(
          color: const Color(0xffaaabac),
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(5, 10),
            ),
          ],
        ),
        child: Center(
          child: buttonContent,
        ),
      ),
    );
  }
}
