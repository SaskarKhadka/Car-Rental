import 'package:flutter/material.dart';

class TimeState extends ChangeNotifier {
  String pickUpTime =
      "${TimeOfDay.now().hourOfPeriod}:${TimeOfDay.now().minute} ${TimeOfDay.now().period.name}";
  String dropOffTime =
      "${TimeOfDay.now().hourOfPeriod}:${TimeOfDay.now().minute} ${TimeOfDay.now().period.name}";

  updatePickUpTime(String time) {
    pickUpTime = time;
    notifyListeners();
  }

  updateDropOffTime(String time) {
    dropOffTime = time;
    notifyListeners();
  }

  reset() {
    TimeOfDay? today = TimeOfDay.now();
    pickUpTime = "${today.hour}:${today.minute} ${today.period.name}";
    dropOffTime = pickUpTime;
    notifyListeners();
  }
}
