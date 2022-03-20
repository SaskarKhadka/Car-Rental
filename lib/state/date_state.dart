import 'package:flutter/cupertino.dart';

class DateState extends ChangeNotifier {
  String pickUpDate =
      "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}";
  String dropOffDate =
      "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}";

  updatePickUpDate(String date) {
    pickUpDate = date;
    notifyListeners();
  }

  updateDropOffDate(String date) {
    dropOffDate = date;
    notifyListeners();
  }

  reset() {
    DateTime? today = DateTime.now();
    pickUpDate = "${today.year}/${today.month}/${today.day}";
    dropOffDate = pickUpDate;
    notifyListeners();
  }
}
