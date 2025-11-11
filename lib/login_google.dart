import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth_controller.dart';
import 'package:get/get.dart';

class LoginGoogle extends StatelessWidget {
  const LoginGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text("Sign in with Google"),
          onPressed: controller.signInWithGoogle,
        ),
      ),
    );
  }
}
