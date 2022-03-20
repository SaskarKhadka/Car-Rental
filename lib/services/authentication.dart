import 'package:car_rental/components/custom_exception.dart';
import 'package:car_rental/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static String get userID {
    User? user = currentUser;
    return user!.uid;
  }

  static Future<void> signUp(
      {required Map<String, dynamic> userData,
      required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: userData["email"], password: password);
      await Database.addUser(userData);
    } on FirebaseAuthException catch (ex) {
      // throw error
      throw CustomException(ex.message!);
    }
  }

  static Future<void> signIn({String? email, String? password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
    } on FirebaseAuthException catch (ex) {
      throw CustomException(ex.message!);
    }
  }

  static Future<bool> isEmailVerified() async {
    User? user = currentUser;
    await user!.reload();
    if (user.emailVerified) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> reload() async {
    User? user = currentUser;
    return await user!.reload();
  }

  static Future<void> sendEmailVerification({String? email}) async {
    User? user = currentUser;
    try {
      await user!.sendEmailVerification();
    } on FirebaseAuthException catch (ex) {
      throw CustomException(ex.message!);
    }
  }

  static Future<void> passwordReset({String? email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email!);
    } on FirebaseAuthException catch (ex) {
      throw CustomException(ex.message!);
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }
}
