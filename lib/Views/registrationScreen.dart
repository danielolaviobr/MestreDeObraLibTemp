import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mestre_de_obra/Controllers/RegistrationControllers/RegistrationController.dart';
import 'package:mestre_de_obra/Widgets/RegistrationWidgets/EmailInput.dart';
import 'package:mestre_de_obra/Widgets/RegistrationWidgets/PasswordInput.dart';
import 'package:mestre_de_obra/Widgets/RegistrationWidgets/PhoneInput.dart';
import 'package:mestre_de_obra/Widgets/RegistrationWidgets/RegisterButton.dart';
import 'package:mestre_de_obra/Widgets/RegistrationWidgets/RegistrationBackground.dart';

class RegistrationScreen extends StatelessWidget {
  static String id = '/registration';
  final RegistrationController registrationController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder(
        init: registrationController,
        builder: (controller) => RegistrationBackground(
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
                  RegistrationEmailInput(
                    controller: controller,
                    nextFocus: FocusState.Phone,
                    onChange: (email) => controller.updateEmail(email),
                  ),
                  RegistrationPhoneInput(
                    focusNode: controller.phoneFocus,
                    controller: controller,
                    nextFocus: FocusState.Password,
                    onChange: (phone) => controller.updatePhone(phone),
                  ),
                  RegistrationPasswordInput(
                    label: 'Senha',
                    action: TextInputAction.go,
                    focusNode: controller.passwordFocus,
                    controller: controller,
                    nextFocus: FocusState.PasswordRepeat,
                    onChange: (password) => controller.updatePassword(password),
                  ),
                  RegistrationPasswordInput(
                    label: 'Repita sua senha',
                    action: TextInputAction.send,
                    focusNode: controller.passwordRepeatFocus,
                    controller: controller,
                    nextFocus: FocusState.SignUp,
                    onChange: (passwordRepeat) =>
                        controller.updatePasswordRepeat(passwordRepeat),
                  ),
                  Expanded(
                    flex: context.mediaQueryViewInsets.bottom == 0 ? 2 : 1,
                    child: SizedBox(),
                  ),
                  // When 0 means that the keyboard is hidden
                  context.mediaQueryViewInsets.bottom == 0
                      ? Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(left: 150),
                            width: 210,
                            padding: EdgeInsets.only(left: 0),
                            child: RegisterButton(
                              onTap: () => controller.performSignUp(),
                            ),
                          ),
                        )
                      : SizedBox(),
                  Expanded(
                    flex: context.mediaQueryViewInsets.bottom == 0 ? 2 : 1,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
