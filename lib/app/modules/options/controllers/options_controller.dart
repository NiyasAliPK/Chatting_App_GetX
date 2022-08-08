import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OptionsController extends GetxController {
  GoogleSignInAccount? user;
  bool isButtonClicked = false;

  changePage(value) {
    isButtonClicked = value;
    update();
  }

  googleLogin() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (await googleSignIn.isSignedIn() == false) {
        return;
      }
      user = googleSignInAccount;
      final googleAuth = await googleSignInAccount!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (e) {
      Get.snackbar(e.toString(), '');
    }
  }
}
