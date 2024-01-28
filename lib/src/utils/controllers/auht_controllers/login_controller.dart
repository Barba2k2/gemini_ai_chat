import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../screens/chat/chat_page.dart';
import '../../consts/text_strings.dart';
import '../../helper/helper.dart';
import '../../models/user_model.dart';
import '../../repository/auth_repository.dart';
import '../../repository/user_repository/user_repository.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final showPasswod = false.obs;
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final resetPassEmailFormKey = GlobalKey<FormState>();
  final resetPasswordEmailFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    try {
      isLoading.value = true;

      if (!loginFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      final auth = AuthRepository.instance;

      final loginResult = await auth.loginWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!loginResult.success) {
        Helper.errorSnackBar(
          title: tOps,
          message: loginResult.errorMessage!,
        );
        isLoading.value = false;
        return;
      }

      auth.setInitialScreen(auth.firebaseUser);
    } catch (e) {
      isLoading.value = false;
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }

  Future<void> googleSignIn() async {
    try {
      isGoogleLoading.value = true;
      final auth = AuthRepository.instance;

      await auth.signInWithGoogle();
      isGoogleLoading.value = false;

      if (!await UserRepository.instance.recordExist(auth.getUserEmail)) {
        UserModel user = UserModel(
          id: auth.getUserId,
          email: auth.getUserEmail,
          password: '',
          fullName: auth.getDisplayName,
        );
        await UserRepository.instance.createUserWithGoogle(user);
        Get.to(() => const ChatPage());
      }
    } catch (e) {
      isGoogleLoading.value = false;
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }

  Future<void> resetPasswordEmail() async {
    try {
      if (resetPassEmailFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }
      isLoading.value = true;

      await AuthRepository.instance.resetPasswordEmail(
        emailController.text.trim(),
      );
    } catch (e) {
      isLoading.value = false;
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }
}
