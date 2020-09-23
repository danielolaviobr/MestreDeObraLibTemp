import 'package:flutter/material.dart';

import '../../constants.dart';

class LoginButtonSignUp extends StatelessWidget {
  final Function onTap;
  LoginButtonSignUp({this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 8, left: 10.0, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 6),
                Icon(
                  Icons.keyboard_arrow_left,
                  size: 40,
                  color: Colors.white,
                ),
              ],
            ),
            Text(
              'Cadastro',
              style: kLogInButton,
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Color(0xFF4D4D4D),
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
