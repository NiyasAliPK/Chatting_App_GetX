import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  bool isDarkModeOn = false;
  TextEditingController searchController = TextEditingController();
  QuerySnapshot? searchData;
  QuerySnapshot? currentUserDetails;
  final switchDataController = GetStorage();

  @override
  onInit() async {
    super.onInit();
    readDataFromGetxStorage();
  }

  // changeTheme(value) {
  //   isDarkModeOn = value;
  //   update();

  // }

  searchUserByUserName(String querry) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("name", isEqualTo: querry)
        .get()
        .then((value) {
      searchData = value;
      update();
    });
  }

  changeSwitchState(bool value) async {
    await switchDataController.write('DarkModeTurnedOn', value);
    await readDataFromGetxStorage();
  }

  readDataFromGetxStorage() async {
    if (switchDataController.read('DarkModeTurnedOn') != null) {
      isDarkModeOn = await switchDataController.read('DarkModeTurnedOn');
      update();
      if (isDarkModeOn == true) {
        Get.changeTheme(ThemeData.dark());
      } else {
        Get.changeTheme(ThemeData.light());
      }
    }
  }
  // getCurrentuserDetails({required String currentuserName}) async {
  //   if (currentuserName.isEmpty) {
  //     return;
  //   }
  //   return await FirebaseFirestore.instance
  //       .collection('users')
  //       .where("name", isEqualTo: currentuserName)
  //       .get()
  //       .then((value) {
  //     currentUserDetails = value;
  //     update();
  //     log('COMPLETED');
  //   });
  // }
}
