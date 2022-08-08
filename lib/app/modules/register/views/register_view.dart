import 'dart:convert';

import 'package:chat_app/app/modules/options/controllers/options_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  final RegisterController _registerController = Get.put(RegisterController());
  final OptionsController _optionsController = Get.put(OptionsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetBuilder<RegisterController>(builder: (controller) {
                    return Container(
                      margin: const EdgeInsets.only(left: 15, bottom: 15),
                      height: 105,
                      width: 105,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/profile.png')),
                      ),
                      child: controller.img.trim().isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(const Base64Decoder()
                                  .convert(controller.img)),
                            )
                          : Container(),
                    );
                  }),
                  IconButton(
                      onPressed: () async {
                        controller.pickimage();
                      },
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.black,
                        size: 35,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return 'Please enter valid name';
                        }
                        return null;
                      },
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        hintText: "Name",
                        prefixIcon: Icon(Icons.face_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      maxLength: 10,
                      validator: (value) {
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(value!)) {
                          return 'please enter valid number';
                        } else {
                          return null;
                        }
                      },
                      controller: controller.numberController,
                      decoration: InputDecoration(
                        hintText: "Mobile No",
                        prefixIcon: Icon(Icons.phone_android),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$')
                                    .hasMatch(value!) ||
                                value.length < 3) {
                              return 'please enter valid email';
                            } else {
                              return null;
                            }
                          },
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            hintText: "Email ID",
                            prefixIcon: Icon(Icons.alternate_email),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 6
                                  ? "Enter min. 6 characters"
                                  : null,
                          controller: controller.passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock_rounded),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 6
                                  ? "Enter min. 6 characters"
                                  : null,
                          controller: controller.confPasswordController,
                          decoration: InputDecoration(
                            hintText: "Conform Password",
                            prefixIcon: Icon(Icons.lock_rounded),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await controller.signUp(
                            controller.emailController.text.trim(),
                            controller.passwordController.text.trim(),
                            controller.confPasswordController.text.trim());
                      },
                      child: Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 40),
                          primary: Color.fromARGB(255, 12, 119, 206)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        _optionsController.changePage(false);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 36),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Already have an account?  ",
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue))
                          ],
                        ),
                        textScaleFactor: 0.5,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
