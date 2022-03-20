import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  static const String id = "/payment";
  final Map<String, dynamic>? args;
  const Payment({Key? key, this.args}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      top: false,
      child: Scaffold(
        body: Text(
          "Hi",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
