import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class FileCard extends StatelessWidget {
  final String fileName;
  final String updatedAt;
  final bool downloadStatus;
  final Function onTap;
  FileCard({this.fileName, this.updatedAt, this.downloadStatus, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: this.onTap,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          height: 100,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        this.fileName,
                        style: kFileTextStyle,
                      ),
                    ),
                    Text(
                      this.updatedAt,
                      style: kFileTextStyle,
                    )
                  ],
                ),
              ),
              this.downloadStatus
                  ? SvgPicture.asset(
                      'assets/Home Assets/downloadedIcon.svg',
                      width: 30,
                      height: 30,
                    )
                  : SvgPicture.asset(
                      'assets/Home Assets/downloadIcon.svg',
                      width: 30,
                      height: 30,
                    )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [kCardShaddow],
          ),
        ));
  }
}
