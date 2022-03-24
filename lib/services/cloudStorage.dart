import 'dart:io';
import 'package:car_rental/components/custom_exception.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  static String userID = Authentication.userID;
  static final instance = FirebaseStorage.instance;

  //uploads file in firebase storage
  static Future<bool> uploadProfilePicture(File image) async {
    final ref = instance.ref('profilePics/$userID');
    try {
      ListResult listResult;
      String prevProfileName;
      try {
        listResult = await ref.listAll();
        if (listResult.items.isNotEmpty) {
          prevProfileName = listResult.items[0].name;
          deleteFile(prevProfileName);
        }
      } on FirebaseException catch (ex) {
        throw CustomException(ex.message!);
      }

      String dateTime = DateTime.now()
          .toString()
          .replaceAll('.', '')
          .replaceAll(':', '')
          .replaceAll('-', '')
          .replaceAll(' ', '');

      try {
        await ref.child(userID + dateTime).putFile(image);
        String url = await profileUrl(userID + dateTime);
        await Database.updateProfileUrl(url);
        return true;
      } catch (ex) {
        return false;
      }
    } on FirebaseException catch (ex) {
      print(ex.code);
      return false;
    }
  }

  static deleteFile(String prevProfileName) async {
    await instance.ref('profilePics/$userID/$prevProfileName').delete();
  }

  static Future<String> profileUrl(String profileName) async {
    return await instance
        .ref('profilePics/$userID/$profileName')
        .getDownloadURL();
  }

  static Future<String> genericProfileUrl() async {
    return await instance.ref("genericprofile/profile.jpg").getDownloadURL();
  }

  static Future<String> uploadCarPic(File image, String? regNo) async {
    String dateTime = DateTime.now()
        .toString()
        .replaceAll('.', '')
        .replaceAll(':', '')
        .replaceAll('-', '')
        .replaceAll(' ', '');
    final ref = instance.ref('carPics/$regNo').child(dateTime);

    try {
      await ref.putFile(image);
      String url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (ex) {
      throw CustomException(ex.message!);
    }
  }
}
