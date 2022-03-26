import 'dart:io';
import 'package:car_rental/components/custom_exception.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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

  static citizenshipPics(List<XFile?> files) async {
    final ref = instance.ref('citizenshipPics/$userID');
    try {
      ListResult listResult;
      // String prevProfileName;
      try {
        listResult = await ref.listAll();
        if (listResult.items.isNotEmpty) {
          for (final each in listResult.items) {
            String? name = each.name;
            await instance.ref('citizenshipPics/$userID/$name').delete();
          }
        }
      } on FirebaseException catch (ex) {
        throw CustomException(ex.message!);
      }

      List<String> citizenshipUrls = [];
      int side = 1;
      for (final eachFile in files) {
        try {
          File? image = File(eachFile!.path);
          await ref.child("side $side").putFile(image);
          String url = await ref.child("side $side").getDownloadURL();
          citizenshipUrls.add(url);
          side++;
        } catch (ex) {
          throw CustomException(ex.toString());
        }
      }
      await Database.addCitizenshipPics(citizenshipUrls);
    } on FirebaseException catch (ex) {
      throw CustomException(ex.toString());
    }
  }

  static lisencePics(List<XFile?> files) async {
    final ref = instance.ref('lisencePics/$userID');
    try {
      ListResult listResult;
      // String prevProfileName;
      try {
        listResult = await ref.listAll();
        if (listResult.items.isNotEmpty) {
          for (final each in listResult.items) {
            String? name = each.name;
            await instance.ref('lisencePics/$userID/$name').delete();
          }
        }
      } on FirebaseException catch (ex) {
        throw CustomException(ex.message!);
      }

      List<String> lisenceUrls = [];
      int side = 1;
      for (final eachFile in files) {
        try {
          File? image = File(eachFile!.path);
          await ref.child("side $side").putFile(image);
          String url = await ref.child("side $side").getDownloadURL();
          lisenceUrls.add(url);
          side++;
        } catch (ex) {
          throw CustomException(ex.toString());
        }
      }
      await Database.addLisencePics(lisenceUrls);
    } on FirebaseException catch (ex) {
      throw CustomException(ex.toString());
    }
  }
}
