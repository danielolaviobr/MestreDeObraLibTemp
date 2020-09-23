import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class ProjectCard extends StatelessWidget {
  final String project;
  final Function onTap;
  ProjectCard({this.project, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        height: 80,
        width: Get.width,
        child: Text(
          this.project,
          style: kProjectTextStyle,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            kCardShaddow
          ],
        ),
      ),
    );
  }
}
