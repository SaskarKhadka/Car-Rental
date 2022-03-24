import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class CarPicsState extends ChangeNotifier {
  List<XFile?> carPics = [];

  changeState(List<XFile?> state) {
    carPics = state;
    notifyListeners();
  }
}
