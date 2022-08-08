import 'package:get/get.dart';

import '../controllers/view_all_users_controller.dart';

class ViewAllUsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewAllUsersController>(
      () => ViewAllUsersController(),
    );
  }
}
