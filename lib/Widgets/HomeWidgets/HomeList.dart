import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mestre_de_obra/Controllers/HomeControllers/HomeControllers.dart';
import 'package:mestre_de_obra/Widgets/HomeWidgets/projectCard.dart';

import 'fileCard.dart';

class HomeList extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return homeController.isProjectScreen
        ? ListView.builder(
            itemCount: homeController.projects.length,
            itemBuilder: (context, index) {
              return ProjectCard(
                project: homeController.projects[index],
                onTap: () =>
                    homeController.getFilesData(homeController.projects[index]),
              );
            },
          )
        : ListView.builder(
            itemCount: homeController.filesData.length,
            itemBuilder: (context, index) {
              return FileCard(
                fileName: homeController.filesData[index].name,
                onTap: () => homeController.openFileOrDownloadAndOpen(
                  homeController.filesData[index].name,
                  homeController.currentProject,
                  homeController.filesData[index].docId,
                ),
                downloadStatus: homeController.filesData[index].downloaded,
                updatedAt: DateFormat('dd/MM/yyyy')
                    .format(homeController.filesData[index].updatedAt.toDate()),
              );
            },
          );
  }
}
