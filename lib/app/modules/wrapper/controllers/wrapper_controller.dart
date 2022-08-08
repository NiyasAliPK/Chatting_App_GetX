import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class WrapperController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}
