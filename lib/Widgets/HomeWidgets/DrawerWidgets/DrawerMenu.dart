import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mestre_de_obra/Controllers/HomeControllers/HomeControllers.dart';
import 'package:mestre_de_obra/Views/paymentScreen.dart';
import 'package:mestre_de_obra/Widgets/HomeWidgets/DrawerWidgets/DrawerMenuItem.dart';

class DrawerMenu extends StatelessWidget {
  final HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1982c4),
            Color(0xFF1C90D9),
            Color(0xFF269BE3),
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 50),
          SizedBox(
            height: 500,
            child: ListView(
              children: [
                DrawerMenuItem(
                  title: 'Projetos',
                  icon: 'assets/Home Assets/homeIcon.svg',
                  onTap: () => homeController.projectsHomeDrawer(),
                ),
                ...homeController.projectsDrawerItems ?? [],
                DrawerMenuItem(
                  title: 'Cobrança',
                  icon: 'assets/Home Assets/moneyIcon.svg',
                  onTap: () => Get.toNamed(PaymentScreen.id),
                ),
                DrawerMenuItem(
                  title: 'Sair',
                  icon: 'assets/Home Assets/logoutIcon.svg',
                  onTap: () => homeController.signOut(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
