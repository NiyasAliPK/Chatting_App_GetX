import 'package:chat_app/app/data/db/database_controller.dart';
import 'package:chat_app/app/modules/chat/controllers/chat_controller.dart';
import 'package:chat_app/app/modules/recent/controllers/recent_controller.dart';
import 'package:chat_app/app/modules/register/controllers/register_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final HomeController _homeController = Get.put(HomeController());
  final RegisterController _registerController = Get.put(RegisterController());
  final DataBaseController _dataBaseController = Get.put(DataBaseController());
  final RecentController _recentController = Get.put(RecentController());
  final ChatController _chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    _registerController.userName.value =
        FirebaseAuth.instance.currentUser!.displayName!;
    _recentController.getRecentChatRoom(
        currentUserName: FirebaseAuth.instance.currentUser!.displayName!);
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      // _homeController.currentUserDetails!.docs[0]['image']
                      //         .toString()
                      //         .isEmpty
                      //     ? Container()
                      //     : CircleAvatar(
                      //         radius: 50,
                      //         backgroundImage: MemoryImage(Base64Decoder()
                      //             .convert(_homeController
                      //                 .currentUserDetails!.docs[0]['image']
                      //                 .toString())),
                      //    ),
                      Obx(() {
                        return Text(
                          _registerController.userName.value.capitalizeFirst!,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        );
                      })
                    ],
                  )),
              ListTile(
                title: const Text('Dark Mode'),
                trailing: GetBuilder<HomeController>(builder: (_) {
                  return Switch(
                      value: _homeController.isDarkModeOn,
                      onChanged: (value) {
                        _homeController.changeSwitchState(value);
                      });
                }),
                onTap: () {},
              ),
              ListTile(
                title: Text("All users"),
                onTap: () async {
                  await _recentController.getRecentChatRoom(
                      currentUserName: _registerController.userName.value);
                  Get.toNamed('/view-all-users');
                },
              ),
              ListTile(
                title: Text("Recent Chats"),
                onTap: () {
                  Get.toNamed('/recent',
                      arguments: _registerController.userName.value);
                },
              ),
              ListTile(
                title: const Text('Logout'),
                trailing: Icon(Icons.logout),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                child: TextFormField(
                  onChanged: (value) {
                    if (value ==
                        FirebaseAuth.instance.currentUser!.displayName) {
                      Get.snackbar("You cannot message your self", '');
                      return;
                    }
                    _homeController.searchUserByUserName(value);
                  },
                  decoration: InputDecoration(
                    suffixIcon:
                        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: GetBuilder<HomeController>(builder: (controller) {
                  return controller.searchData == null
                      ? Container(
                          child: Center(
                            child: Text('Please enter username to search.'),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _homeController.searchData!.docs.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            final data =
                                _homeController.searchData!.docs[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 134, 134, 134),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: ListTile(
                                onTap: () {},
                                leading: Text(
                                  data['name'],
                                ),
                                trailing: TextButton(
                                    onPressed: () async {
                                      await _chatController.getChatterDetails(
                                          chatterName: data['name']);
                                      await _dataBaseController
                                          .createChatCoversation(
                                              userName: data['name'],
                                              currentUser: _registerController
                                                  .userName.value);
                                    },
                                    child: Text('Message',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold))),
                              ),
                            );
                          },
                        );
                }),
              )
            ],
          ),
        ));
  }
}
