import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  TextEditingController messageEditingController = TextEditingController();
  final List messages = [];
  QuerySnapshot? chattingTo;

  addMessages({required String chatRoomId, required String currentUser}) async {
    final Map<String, dynamic> messageMap = {
      "message": messageEditingController.text,
      "sendby": currentUser
    };
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('Chats')
        .doc(DateTime.now().toString())
        .set(messageMap)
        .catchError((e) {
      Get.snackbar(e.toString(), '');
    });
  }

  getConversationsMessages({required chatRoomId}) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('Chats')
        .where('message')
        .snapshots()
        .forEach((element) {
      messages.clear();
      element.docs.map((DocumentSnapshot document) {
        Map a = document.data() as Map<String, dynamic>;
        messages.add(a);
        messages;
      }).toList();
      update();
    });
  }

  getChatterDetails({required String chatterName}) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: chatterName)
        .get()
        .then((value) {
      chattingTo = value;
      log("${chattingTo.toString()} completed");
    });
  }
}
