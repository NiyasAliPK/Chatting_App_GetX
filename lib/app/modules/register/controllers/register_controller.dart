import 'dart:convert';
import 'dart:io';

import 'package:chat_app/app/data/db/database_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxString userName = ''.obs;
  final DataBaseController _dataBaseController = Get.put(DataBaseController());
  String img = '';

  bool checkPassword(String pass1, String pass2) {
    if (pass1 == pass2) {
      return true;
    } else {
      return false;
    }
  }

  signUp(String email, String password, String pass2) async {
    final isvalid = formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    bool passTrue = checkPassword(password, pass2);
    if (passTrue == false) {
      Get.snackbar("The passwords entered doesn't match", "");
      return;
    }
    Get.defaultDialog(
        content: CircularProgressIndicator(), title: 'Please wait...');
    try {
      final UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(nameController.text.toString());
      userName.value = FirebaseAuth.instance.currentUser!.displayName!;
      _dataBaseController.updateUserData(
          nameController.text.toString(),
          jobController.text.toString(),
          numberController.text.toString(),
          result.user!.uid,
          img,
          result.user!.email!,
          result.user!.uid);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      Get.snackbar(e.message.toString(), '');
      return;
    }
    Get.back();
    Get.back();
    nameController.clear();
    numberController.clear();
    jobController.clear();
    emailController.clear();
    passwordController.clear();
    img = '';
  }

  pickimage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return;
    } else {
      update();
      final bytes = File(pickedImage.path).readAsBytesSync();
      img = base64Encode(bytes);
      update();
      if (img != '') {
        Get.snackbar(
          "Image picked",
          '',
          colorText: Colors.white,
        );
      }
    }
  }
}
