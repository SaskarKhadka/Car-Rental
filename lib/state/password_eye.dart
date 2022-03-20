import 'package:flutter/cupertino.dart';

class PasswordEyeState extends ChangeNotifier {
  bool seePassword = true;

  changeState() {
    seePassword = !seePassword;
    notifyListeners();
  }
}
