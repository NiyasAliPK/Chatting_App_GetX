import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/view_all_users_controller.dart';

class ViewAllUsersView extends GetView<ViewAllUsersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All Users'),
          centerTitle: true,
        ),
        body: SafeArea(
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print("Error loading the data from fireStore");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final List usersList = [];
                  snapshot.data!.docs.map((documentSnapshot) {
                    Map temp = documentSnapshot.data() as Map<String, dynamic>;
                    usersList.add(temp);
                  }).toList();
                  return ListView.separated(
                    itemCount: usersList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 15);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final data = usersList[index];
                      return ListTile(
                        title: Text("${data['name']}"),
                        trailing: data['name'] !=
                                FirebaseAuth.instance.currentUser!.displayName
                            ? ElevatedButton(
                                child: Text('Copy'),
                                onPressed: () {
                                  Clipboard.setData(
                                          ClipboardData(text: data['name']))
                                      .then((result) {
                                    Get.snackbar(
                                        'User name copied to clipboard', '',
                                        padding: EdgeInsets.only(left: 80),
                                        isDismissible: true);
                                  });
                                },
                              )
                            : Text(
                                'You',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20),
                              ),
                      );
                    },
                  );
                })));
  }
}
