import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mestre_de_obra/Controllers/RegistrationControllers/RegistrationController.dart';

import '../../constants.dart';

class RegistrationPhoneInput extends StatelessWidget {
  final FocusNode focusNode;
  final Function onFocusChange;
  final RegistrationController controller;
  final FocusState nextFocus;
  final Function onChange;

  const RegistrationPhoneInput(
      {this.focusNode,
      this.onFocusChange,
      this.controller,
      this.nextFocus,
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
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.go,
          inputFormatters: [controller.maskFormatter],
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'Telefone',
            labelStyle: kLogInTextFieldTheme,
            focusColor: Color(0xFF5ABFE7),
          ),
          onChanged: (phone) {
            this.onChange(phone);
          },
        ),
        width: Get.width * 0.8,
        height: 80,
      ),
    );
  }
}
