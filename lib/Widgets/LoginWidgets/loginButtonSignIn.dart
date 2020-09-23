import 'package:flutter/material.dart';

import '../../constants.dart';

class LoginButtonSignIn extends StatelessWidget {
  final Function onTap;
  LoginButtonSignIn({this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 8, left: 20.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Entrar',
              style: kLogInButton,
            ),
            //SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 6),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 40,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Color(0xFF68CAF0),
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
