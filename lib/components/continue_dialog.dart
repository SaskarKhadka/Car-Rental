//TODO: make do you wish to continue dialog
import 'package:flutter/material.dart';

Widget continueDialog({
  String? title,
  String? message,
  VoidCallback? onYes,
  VoidCallback? onNo,
}) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(10.0),
      height: 150,
      // width: MediaQuery.of(context).size.width * 0.7,
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Flexible(
          child: Text(
            title!,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25.0,
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Flexible(
          child: Text(
            message!,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Container(
            //   padding: const EdgeInsets.all(5.0),
            //   decoration: BoxDecoration(
            //     color: Colors.black,
            //     borderRadius: BorderRadius.circular(5.0),
            //   ),
            //   child: GestureDetector(
            //     onTap: onYes,
            //     child: const Text("Yes"),
            //   ),
            // ),
            ElevatedButton(
              onPressed: onYes,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.black,
                ),
              ),
              child: Text("Yes"),
            ),
            ElevatedButton(
              onPressed: onNo,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.black,
                ),
              ),
              child: Text("No"),
            ),
          ],
        ),
      ]),
    ),
  );
}
