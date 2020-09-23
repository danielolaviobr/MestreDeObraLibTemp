import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mestre_de_obra/Controllers/RegistrationControllers/RegistrationController.dart';

import '../../constants.dart';

class RegistrationPasswordInput extends StatelessWidget {
  final String label;
  final TextInputAction action;
  final FocusNode focusNode;
  final RegistrationController controller;
  final FocusState nextFocus;
  final Function onChange;
  RegistrationPasswordInput(
      {this.label,
      this.action,
      this.controller,
      this.nextFocus,
      this.focusNode,
      this.onChange});
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
            textInputAction: this.action,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: this.label,
              labelStyle: kLogInTextFieldTheme,
            ),
            onChanged: (password) {
              this.onChange(password);
            }),
        width: Get.width * 0.8,
        height: 80,
      ),
    );
  }
}
