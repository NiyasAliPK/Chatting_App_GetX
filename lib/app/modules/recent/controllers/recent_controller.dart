import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RecentController extends GetxController {
  List users = [];
  getRecentChatRoom({required String currentUserName}) async {
    users.clear();
    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where("users", arrayContains: currentUserName)
        .get()
        .then((value) {
      value.docs.map((DocumentSnapshot document) {
        Map a = document.data() as Map<String, dynamic>;
        users.add(a);
      }).toList();
      update();
    });
  }
}
