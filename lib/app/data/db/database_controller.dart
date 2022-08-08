import 'package:chat_app/app/modules/chat/controllers/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataBaseController extends GetxController {
  final userCollection = FirebaseFirestore.instance.collection('users');
  final chatRoomCollection = FirebaseFirestore.instance.collection('ChatRoom');
  final ChatController _chatController = Get.put(ChatController());
  String? exisitingChatRoom;

  RxList<String> searchResults = <String>[].obs;

  ///CREATE CHATROOM FOR PERSONAL CHAT
  createChatRoom({required String chatRoomId, required chatRoomMap}) async {
    chatRoomCollection.doc(chatRoomId).set(chatRoomMap).catchError((e) {
      Get.snackbar(e.toString(), '');
    });
  }

  ///CREATE CHAT CONVERSATIONS
  createChatCoversation(
      {required String userName, required String currentUser}) async {
    String? chatRoomId;
    await checkForExistingChatRoom(
        userName: userName, currentUser: currentUser);
    if (exisitingChatRoom!.isEmpty) {
      List<String> usersList = [userName, currentUser];

      chatRoomId = createChatRoomId(a: userName, b: currentUser);
      Map<String, dynamic> chatRoomMap = {
        "users": usersList,
        "roomId": chatRoomId
      };
      await createChatRoom(chatRoomId: chatRoomId!, chatRoomMap: chatRoomMap);
    }

    await _chatController.getConversationsMessages(
        chatRoomId:
            exisitingChatRoom!.isNotEmpty ? exisitingChatRoom : chatRoomId);
    Get.toNamed('/chat',
        arguments:
            exisitingChatRoom!.isNotEmpty ? exisitingChatRoom : chatRoomId);
  }

  /// CREATE USER DEATILS FOR NEW USERS
  updateUserData(String name, String job, String mobile, String uid,
      String image, String email, String id) async {
    final userCollection =
        FirebaseFirestore.instance.collection('users').doc(uid);

    final data = {
      "name": name,
      "mob": mobile,
      "image": image,
      "email": email,
      "id": id
    };

    await userCollection.set(data);
  }

  /// CREATE CHAT ROOM ID
  createChatRoomId({required String a, required String b}) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "${b}_$a";
    } else {
      return "${a}_$b";
    }
  }

  createChatRoomId2({required String a, required String b}) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "${a}_$b";
    } else {
      return "${b}_$a";
    }
  }

  /// CHECK FOR EXISTING CHAT ROOM FOR USERS
  checkForExistingChatRoom(
      {required String userName, required String currentUser}) async {
    exisitingChatRoom = '';
    final roomId = createChatRoomId(a: userName, b: currentUser);
    final roomId2 = createChatRoomId2(a: currentUser, b: userName);

    final search = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(roomId)
        .get();
    if (search.data() != null) {
      exisitingChatRoom = roomId;
      return;
    } else {
      final search2 = await FirebaseFirestore.instance
          .collection('ChatRoom')
          .doc(roomId2)
          .get();
      if (search2.data() != null) {
        exisitingChatRoom = roomId2;
        return;
      }
    }
  }
}
