import 'package:flutter/material.dart';

import '../../constants.dart';

class RegisterButton extends StatelessWidget {
  final Function onTap;
  RegisterButton({this.onTap});
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
              'Cadastrar',
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
          color: Color(0xFFFFAF07),
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
