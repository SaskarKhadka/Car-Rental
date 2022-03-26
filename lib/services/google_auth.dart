import 'package:car_rental/components/custom_exception.dart';
import 'package:car_rental/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static final googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> selectAccount() async {
    final googleAccount = await googleSignIn.signIn();
    return googleAccount;
  }

  static signIn(GoogleSignInAccount? googleAccount) async {
    try {
      final googleAuth = await googleAccount!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (ex) {
      throw CustomException(ex.message!);
    }
  }

  static signOut() async {
    await googleSignIn.disconnect();
  }
}
