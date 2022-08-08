import 'package:chat_app/app/modules/login/views/login_view.dart';
import 'package:chat_app/app/modules/register/views/register_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/options_controller.dart';

class OptionsView extends GetView<OptionsController> {
  final OptionsController _optionsController = Get.put(OptionsController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OptionsController>(builder: (controller) {
      return controller.isButtonClicked == false ? LoginView() : RegisterView();
    });
  }
}
