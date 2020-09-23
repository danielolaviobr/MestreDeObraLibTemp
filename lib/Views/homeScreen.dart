import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mestre_de_obra/Controllers/HomeControllers/HomeControllers.dart';
import 'package:mestre_de_obra/Widgets/HomeWidgets/DrawerWidgets/DrawerMenu.dart';
import 'package:mestre_de_obra/Widgets/HomeWidgets/HomeList.dart';
import 'package:mestre_de_obra/constants.dart';

class HomeScreen extends StatelessWidget {
  static String id = '/home';
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: homeController,
      builder: (context) {
        return Scaffold(
          body: SliderMenuContainer(
            key: homeController.drawerKey,
            splashColor: Colors.transparent,
            title: Text(
              homeController.title,
              style: kTitleTextStyle,
            ),
            appBarColor: Colors.transparent,
            sliderMenu: DrawerMenu(),
            sliderMain: WillPopScope(
              onWillPop: () => homeController.willPopHandler(),
              child: homeController.isLoading
                  ? Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballRotateChase,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : HomeList(),
            ),
          ),
        );
      },
    );
  }
}
