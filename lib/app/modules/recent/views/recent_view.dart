import 'package:chat_app/app/data/db/database_controller.dart';
import 'package:chat_app/app/modules/chat/controllers/chat_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/recent_controller.dart';

class RecentView extends GetView<RecentController> {
  final currentUserName = Get.arguments;
  final RecentController _recentController = Get.put(RecentController());
  final DataBaseController _dataBaseController = Get.put(DataBaseController());
  final ChatController _chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chats'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView.separated(
            itemCount: _recentController.users.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 15);
            },
            itemBuilder: (BuildContext context, int index) {
              final String chatName =
                  _recentController.users[index]['users'][0] == currentUserName
                      ? _recentController.users[index]['users'][1]
                      : _recentController.users[index]['users'][0];
              return ListTile(
                title: Text(chatName),
                trailing: TextButton.icon(
                    onPressed: () async {
                      await _chatController.getChatterDetails(
                          chatterName: chatName);

                      await _dataBaseController.createChatCoversation(
                          userName: chatName, currentUser: currentUserName);
                    },
                    icon: Icon(Icons.message),
                    label: Text('Message')),
              );
            },
          ),
        ));
  }
}
