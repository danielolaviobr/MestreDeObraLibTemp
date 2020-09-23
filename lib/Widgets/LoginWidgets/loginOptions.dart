import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:mestre_de_obra/Controllers/LogInControllers/LogInController.dart';

import '../../constants.dart';

class LoginOptions extends StatelessWidget {
  final LogInController logInController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        'Outras formas de acesso',
        style: kLogInOptionsTheme,
      ),
      onTap: () => Get.bottomSheet(
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInButton(
                Buttons.Google,
                onPressed: () => logInController.googleSignIn(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
