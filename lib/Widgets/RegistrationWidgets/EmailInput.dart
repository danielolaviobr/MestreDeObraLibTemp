import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mestre_de_obra/Controllers/RegistrationControllers/RegistrationController.dart';

import '../../constants.dart';

class RegistrationEmailInput extends StatelessWidget {
  final FocusNode focusNode;
  final RegistrationController controller;
  final FocusState nextFocus;
  final Function onChange;

  const RegistrationEmailInput(
      {this.focusNode, this.controller, this.nextFocus, this.onChange});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: SizedBox(
        child: TextField(
          focusNode: this.focusNode,
          onSubmitted: (value) {
            this.controller.focusState(this.nextFocus);
          },
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.go,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'E-mail',
            labelStyle: kLogInTextFieldTheme,
            focusColor: Color(0xFF5ABFE7),
          ),
          onChanged: (email) {
            this.onChange(email);
          },
        ),
        width: Get.width * 0.8,
        height: 80,
      ),
    );
  }
}
