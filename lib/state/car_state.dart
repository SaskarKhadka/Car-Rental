import 'package:flutter/cupertino.dart';

class CarState extends ChangeNotifier {
  String? carState = "All";

  changeState(state) {
    carState = state;
    notifyListeners();
  }
}
