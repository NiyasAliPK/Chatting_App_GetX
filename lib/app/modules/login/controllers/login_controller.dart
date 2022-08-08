import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  logIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Please enter your login credentials ", '');
      return;
    }
    Get.defaultDialog(
        content: CircularProgressIndicator(), title: 'Please wait...');
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      Get.snackbar(e.message.toString(), '');
      return;
    }
    Get.back();
    emailController.clear();
    passwordController.clear();
  }
}
