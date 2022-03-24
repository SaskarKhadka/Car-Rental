import 'package:car_rental/components/custom_exception.dart';
import 'package:car_rental/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static final googleSignIn = GoogleSignIn();

  static selectAccount() async {
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
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (!(await Database.userExists(userCredential.user!.uid))) {
        await Database.addUser({
          "name": googleAccount.displayName,
          "email": googleAccount.email,
        });
      }
    } on FirebaseAuthException catch (ex) {
      throw CustomException(ex.message!);
    }
  }
}
