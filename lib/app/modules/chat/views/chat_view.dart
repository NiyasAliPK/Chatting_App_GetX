import 'dart:convert';

import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  final chatRoomId = Get.arguments;
  final ChatController _chatController = Get.put(ChatController());
  ScrollController listScrollController = ScrollController();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final image = _chatController.chattingTo!.docs[0]['image'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(_chatController.chattingTo!.docs[0]['name']
            .toString()
            .capitalizeFirst!),
        actions: [
          _chatController.chattingTo!.docs[0]['image'] == ""
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/profile.png"),
                  ),
                )
              : CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      MemoryImage(const Base64Decoder().convert(image)),
                ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: [
            StreamBuilder(
                stream: _chatController.getConversationsMessages(
                    chatRoomId: chatRoomId),
                builder: (context, snapshot) {
                  return GetBuilder<ChatController>(builder: (_) {
                    return ListView.separated(
                      dragStartBehavior: DragStartBehavior.down,
                      controller: listScrollController,
                      itemCount: _chatController.messages.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 10);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return BubbleNormal(
                            isSender: _chatController.messages[index]
                                        ["sendby"] ==
                                    currentUser!.displayName
                                ? true
                                : false,
                            text: _chatController.messages[index]['message']);
                      },
                    );
                  });
                }),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: _chatController.messageEditingController,
                      decoration: InputDecoration(
                          hintText: "Message ...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () async {
                        _chatController.messages.clear();
                        await _chatController.addMessages(
                            chatRoomId: chatRoomId,
                            currentUser: currentUser!.displayName!);
                        _chatController.getConversationsMessages(
                            chatRoomId: chatRoomId);
                        _chatController.messageEditingController.clear();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(40)),
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.send)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
