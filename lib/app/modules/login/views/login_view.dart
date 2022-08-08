import 'package:chat_app/app/modules/home/controllers/home_controller.dart';
import 'package:chat_app/app/modules/options/controllers/options_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final HomeController _homeController = Get.put(HomeController());
  final OptionsController _optionsController = Get.put(OptionsController());

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GetBuilder<HomeController>(builder: (_) {
              return Container(
                child: Lottie.asset(
                    _homeController.isDarkModeOn == true
                        ? "assets/animations/63787-secure-login-dark.json"
                        : "assets/animations/63787-secure-login.json",
                    animate: true,
                    fit: BoxFit.fill),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: controller.formKey,
                child: Column(
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
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(value!)) {
                          return 'please enter valid number';
                        } else {
                          return null;
                        }
                      },
                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        controller.logIn(controller.emailController.text,
                            controller.passwordController.text);
                      },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 40),
                          primary: Color.fromARGB(255, 12, 119, 206)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        _optionsController.changePage(true);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 36),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Don't have an account?  ",
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                                text: 'Sign up',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue))
                          ],
                        ),
                        textScaleFactor: 0.5,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await _optionsController.googleLogin();
                    },
                    child: Text('Sign Up with Google'))
              ],
            ),
          ],
        ),
      )),
    );
  }
}
