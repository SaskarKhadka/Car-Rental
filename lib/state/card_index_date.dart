import 'package:car_rental/services/database.dart';
import 'package:flutter/cupertino.dart';

class CardIndexState extends ChangeNotifier {
  int? imageIndex = 1;

  changeState(int? state) {
    imageIndex = (imageIndex! + state!) % 2;
    notifyListeners();
  }

  reset() {
    imageIndex = 3;
    notifyListeners();
  }
}
