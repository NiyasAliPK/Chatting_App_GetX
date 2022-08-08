import 'package:get/get.dart';

import 'package:chat_app/app/modules/chat/bindings/chat_binding.dart';
import 'package:chat_app/app/modules/chat/views/chat_view.dart';
import 'package:chat_app/app/modules/home/bindings/home_binding.dart';
import 'package:chat_app/app/modules/home/views/home_view.dart';
import 'package:chat_app/app/modules/login/bindings/login_binding.dart';
import 'package:chat_app/app/modules/login/views/login_view.dart';
import 'package:chat_app/app/modules/options/bindings/options_binding.dart';
import 'package:chat_app/app/modules/options/views/options_view.dart';
import 'package:chat_app/app/modules/recent/bindings/recent_binding.dart';
import 'package:chat_app/app/modules/recent/views/recent_view.dart';
import 'package:chat_app/app/modules/register/bindings/register_binding.dart';
import 'package:chat_app/app/modules/register/views/register_view.dart';
import 'package:chat_app/app/modules/viewAllUsers/bindings/view_all_users_binding.dart';
import 'package:chat_app/app/modules/viewAllUsers/views/view_all_users_view.dart';
import 'package:chat_app/app/modules/wrapper/bindings/wrapper_binding.dart';
import 'package:chat_app/app/modules/wrapper/views/wrapper_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.WRAPPER;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.OPTIONS,
      page: () => OptionsView(),
      binding: OptionsBinding(),
    ),
    GetPage(
      name: _Paths.WRAPPER,
      page: () => WrapperView(),
      binding: WrapperBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.VIEW_ALL_USERS,
      page: () => ViewAllUsersView(),
      binding: ViewAllUsersBinding(),
    ),
    GetPage(
      name: _Paths.RECENT,
      page: () => RecentView(),
      binding: RecentBinding(),
    ),
  ];
}
