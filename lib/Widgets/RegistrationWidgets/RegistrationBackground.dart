import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class RegistrationBackground extends StatelessWidget {
  final List<Widget> children;
  RegistrationBackground({this.children});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: Get.height,
          width: Get.width,
          color: Colors.white,
        ),
        Positioned(
          child: Transform.rotate(
            angle: 150,
            child: Image.asset('assets/Registration Assets/bloob_1.png'),
          ),
          top: -350,
          left: -300,
        ),
        Positioned(
          child: Transform.rotate(
            angle: 180,
            child: Image.asset('assets/Registration Assets/bloob_2.png'),
          ),
          top: -350,
          left: -400,
        ),
        Positioned(
          top: 70,
          left: 40,
          child: Text(
            'Cadastro',
            style: kLogInBackgroundTextTheme,
          ),
        ),
        ...this.children ?? []
      ],
    );
  }
}
