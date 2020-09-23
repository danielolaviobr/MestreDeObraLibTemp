import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mestre_de_obra/constants.dart';

class DrawerMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final Function onTap;
  DrawerMenuItem({this.icon, this.title, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap ?? () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              this.icon,
              width: 30,
              height: 30,
            ),
            SizedBox(width: 20),
            Text(this.title, style: kDrawerMenuItemTextStyle),
          ],
        ),
      ),
    );
  }
}
