import 'package:car_rental/services/database.dart';
import 'package:flutter/cupertino.dart';

class ImageIndexState extends ChangeNotifier {
  int? imageIndex = 1;
  int? totalPics;

  resolveTotalPics(String? carID) async {
    totalPics = await Database.totalCarPics(carID);
    notifyListeners();
  }

  changeState(int? state) async {
    imageIndex = (imageIndex! + state!) % totalPics!;
    notifyListeners();
  }

  reset() {
    imageIndex = 3;
    notifyListeners();
  }
}
