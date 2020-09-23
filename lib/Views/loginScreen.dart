import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mestre_de_obra/Controllers/LogInControllers/LogInController.dart';
import 'package:mestre_de_obra/Views/homeScreen.dart';
import 'package:mestre_de_obra/Views/registrationScreen.dart';
import 'package:mestre_de_obra/Widgets/LoginWidgets/loginBackground.dart';
import 'package:mestre_de_obra/Widgets/LoginWidgets/loginButtonSignIn.dart';
import 'package:mestre_de_obra/Widgets/LoginWidgets/loginButtonSignUp.dart';
import 'package:mestre_de_obra/Widgets/LoginWidgets/loginOptions.dart';

import '../constants.dart';

class LogInScreen extends StatelessWidget {
  static String id = '/login';
  final LogInController logInController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginBackground(
        children: [
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 10,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) => logInController.requestFocus(),
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'E-mail',
                        labelStyle: kLogInTextFieldTheme,
                        focusColor: Color(0xFF5ABFE7),
                      ),
                      onChanged: (email) => logInController.updatedEmail(email),
                    ),
                    width: Get.width * 0.8,
                    height: 80,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    child: TextField(
                      onSubmitted: (value) =>
                          logInController.signInUserAndPushToHome(),
                      textInputAction: TextInputAction.send,
                      autocorrect: false,
                      obscureText: true,
                      focusNode: logInController.loginFocus,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Senha',
                        labelStyle: kLogInTextFieldTheme,
                      ),
                      onChanged: (password) =>
                          logInController.updatedPassword(password),
                    ),
                    width: Get.width * 0.8,
                    height: 80,
                  ),
                ),
                context.mediaQueryViewInsets.bottom == 0
                    ? Expanded(
                        flex: 2,
                        // When 0 means that the keyboard is hidden
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            LoginButtonSignUp(
                              onTap: () => Get.toNamed(RegistrationScreen.id),
                            ),
                            LoginButtonSignIn(
                              onTap: () => Get.offAllNamed(HomeScreen
                                  .id), //logInController.signInUserAndPushToHome(),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                Expanded(
                  flex: 2,
                  child: context.mediaQueryViewInsets.bottom == 0
                      ? SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Esqueci minha senha',
                                  style: kLogInOptionsTheme,
                                ),
                                LoginOptions()
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
