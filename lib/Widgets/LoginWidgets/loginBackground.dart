import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class LoginBackground extends StatelessWidget {
  final List<Widget> children;
  LoginBackground({this.children});
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
            child: Image.asset('assets/Log In Assets/bloob_2.png'),
          ),
          top: -350,
          left: -400,
        ),
        Positioned(
          child: Transform.rotate(
            angle: 150,
            child: Image.asset('assets/Log In Assets/bloob_1.png'),
          ),
          top: -460,
          left: -400,
        ),
        Positioned(
          child: Transform.rotate(
            angle: 180,
            child: Image.asset('assets/Log In Assets/bloob_3.png'),
          ),
          top: -480,
          left: -100,
        ),
        Positioned(
          top: 70,
          left: 40,
          child: Text(
            'Bem\nVindo',
            style: kLogInBackgroundTextTheme,
          ),
        ),
        ...this.children ?? []
      ],
    );
  }
}
