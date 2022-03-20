import 'package:flutter/material.dart';

class WaitingDialog extends StatelessWidget {
  final String title;
  const WaitingDialog({required this.title});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xff141a1e),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      elevation: 10.0,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.black,
              ),
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Text(
              title + '...Please Wait...',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
