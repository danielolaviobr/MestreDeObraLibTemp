import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mestre_de_obra/Controllers/HomeControllers/Support/TickerCreator.dart';
import 'package:mestre_de_obra/Models/auth.dart';
import 'package:mestre_de_obra/Models/database.dart';
import 'package:mestre_de_obra/Models/storage.dart';
import 'package:mestre_de_obra/Views/loginScreen.dart';
import 'package:mestre_de_obra/Widgets/HomeWidgets/DrawerWidgets/DrawerMenuItem.dart';
import 'dart:io' as io;
import 'DownloadController.dart';
import 'Support/FileData.dart';

// ! Remove tickerCreator if not used and handle weird error
class HomeController extends GetxController with TickerCreator {
  Database _db;
  Auth _auth;
  Storage _storage;
  DownloadController _downloadController;
  bool _isLoading = true;
  List<FileData> _filesData = [];
  List<String> _projects = [];
  List<String> _userProjects = [
    'TestA',
    'TestB'
  ]; // ! Remove when user db ready
  List<Widget> projectsDrawerItems = [];
  bool _isProjectScreen = true;
  String _title = 'Projetos';
  String _currentProject;
  GlobalKey<SliderMenuContainerState> drawerKey;

  /// Indicates if there should be a loading indication in the screen
  bool get isLoading => _isLoading;

  /// Returns a list o FileData objects based on the files collection on firebase firestore and the selected project filter
  List<FileData> get filesData => _filesData;

  /// Returns a list of projects registered in firebase firestore, available to the user
  List<String> get projects => _projects;

  /// Determines if the screen is displaying the projects or the files
  bool get isProjectScreen => _isProjectScreen;

  /// Returns the title to be displayed on the top of the HomeScreen
  String get title => _title;

  /// Returns the current project A.K.A. the project corresponding to the files being displayed
  String get currentProject => _currentProject;

  /// Gets the projects available in the db, based on the users permissions and adds to the _projects list
  void getProjectsData() async {
    _title = 'Projetos';
    Stream<QuerySnapshot> projectsData = _db.getProjects(_userProjects);
    projectsData.listen((event) => event.docChanges.forEach((element) {
          switch (element.type) {
            case DocumentChangeType.added:
              // If a document is added it checks if it is already on the projects list, if it isn't adds it
              if (!_projects.contains(element.doc.data()['project'])) {
                _projects.add(element.doc.data()['project']);
              }
              break;
            case DocumentChangeType.modified:
              // If a document is modified it removes the project from the _projects list, and them adds the updated version
              _projects.removeWhere(
                  (project) => project == element.doc.data()['project']);
              _projects.add(element.doc.data()['project']);
              break;
            case DocumentChangeType.removed:
              // If a document is removed it removes it from the _projects list
              _projects.remove(element.doc.data()['project']);
              break;
          }
          update();
          _projects.sort();
          // Calls the loading of the drawer items based on the projects that are available to the user
          projectsDrawer();
        }));
    _isProjectScreen = true;
    _toggleLoading();
  }

  /// Loads the file screen of the selected project and sorts it alphabetically by the name property of the FileData object
  void getFilesData(String selectedProject) async {
    _closeDrawer();
    _filesData = [];
    _title = selectedProject;
    _currentProject = selectedProject;
    _toggleLoading();
    Stream<QuerySnapshot> filesData = _db.getFiles(selectedProject);
    filesData.listen((event) => event.docChanges.forEach((element) async {
          bool _downloaded =
              await _downloadedFileCheck(element.doc.data()['name']);
          switch (element.type) {
            case DocumentChangeType.added:
              // If a document is added to the collection its data will be added to the _filesData list and displayed to the user
              _filesData.add(FileData(
                name: element.doc.data()['name'],
                project: element.doc.data()['project'],
                updatedAt: element.doc.data()['updated'],
                docId: element.doc.id,
                downloaded: _downloaded,
              ));
              break;
            case DocumentChangeType.modified:
              // If a document is modified in the collection this object will be found by docId and removed, and then added in the new modified form to the _filesData list and displayed to the user
              await io.File(await _downloadController
                      .getDownloadFilePath(element.doc.data()['name']))
                  .delete();
              _filesData
                  .removeWhere((fileData) => fileData.docId == element.doc.id);
              _filesData.add(FileData(
                name: element.doc.data()['name'],
                project: element.doc.data()['project'],
                updatedAt: element.doc.data()['updatedAt'],
                docId: element.doc.id,
                downloaded: false,
              ));
              break;
            case DocumentChangeType.removed:
              // If a document is removed from the collection this object will be deleted
              await io.File(await _downloadController
                      .getDownloadFilePath(element.doc.data()['name']))
                  .delete();
              _filesData.remove(FileData(
                name: element.doc.data()['name'],
                project: element.doc.data()['project'],
                updatedAt: element.doc.data()['updatedAt'],
                docId: element.doc.id,
                downloaded: _downloaded,
              ));
              break;
          }
          update();
          _filesData.sort((a, b) => a.name.compareTo(b.name));
        }));
    _isProjectScreen = false;
    _toggleLoading();
  }

  /// Checks if the file is already downloaded in the device
  Future<bool> _downloadedFileCheck(String fileName) async {
    // ? This line initializes the dart io file manager so that it can then check if the file exists properly
    io.File(await _downloadController.getDownloadFilePath(fileName));
    return await io.File(
            await _downloadController.getDownloadFilePath(fileName))
        .exists();
  }

  /// Handles the WillPop action on Android, by always going back to the projects screen
  Future<bool> willPopHandler() async {
    _getBackProjectsData();
    return false;
  }

  /// Checks if the current displayed screen is the projects screen, if not, returns to it
  void _getBackProjectsData() async {
    if (!_isProjectScreen) {
      _toggleLoading();
      getProjectsData();
    }
  }

  /// Toggle the loading animation on and off
  void _toggleLoading() {
    _isLoading = !_isLoading;
    update();
  }

  /// If the drawer is open, closes it
  void _closeDrawer() {
    if (drawerKey.currentState.isDrawerOpen) {
      drawerKey.currentState.closeDrawer();
    }
  }

  /// Gets back to the projects screen if not already in it and closes the drawer
  void projectsHomeDrawer() {
    _getBackProjectsData();
    drawerKey.currentState.closeDrawer();
  }

  /// Loads the selected project screen from the drawer and then closes the drawer
  void projectsItemsDrawer(String project) {
    getFilesData(project);
    _closeDrawer();
  }

  /// Creates the DrawerMenuItems for every avaliable project
  void projectsDrawer() {
    projectsDrawerItems = [];
    projects.sort();
    projects.forEach((project) {
      projectsDrawerItems.add(DrawerMenuItem(
          title: project,
          icon: 'assets/Home Assets/folderIcon.svg',
          onTap: () => projectsItemsDrawer(project)));
    });
    update();
  }

  /// Updates the icon on the fileData object and updates the UI to display it
  void _updateFileDownloadStatus(String docId) {
    FileData _fileData =
        _filesData.firstWhere((fileData) => fileData.docId == docId);
    _fileData.downloaded = true;
    update();
  }

  /// Open the file if already downloaded, if not, downloads and then opens it
  void openFileOrDownloadAndOpen(
      String fileName, String projectName, String docId) async {
    _downloadController.clearErrors();
    _closeDrawer();
    try {
      // Request storage permission if not already granted
      await _downloadController.getPermission();
      // Checks if the file exists in the device storage, if true, opens the file, else downloads the file then opens it
      if (await io.File(await _downloadController.getDownloadFilePath(fileName))
          .exists()) {
        _downloadController.openFileFromName(fileName);
      } else {
        String downloadUrl =
            await _storage.getDownloadLink(fileName, projectName) ??
                NullThrownError();
        _downloadController.downloadAndOpenFile(downloadUrl, fileName);
        _updateFileDownloadStatus(docId);
      }
    } catch (e) {
      Get.snackbar(_downloadController.errorTitle ?? _storage.errorTitle,
          _downloadController.errorMessage ?? _storage.errorMessage);
    }
  }

  /// Listen to the changes in the isDownloading getter and displays loading indication if downloading and closes it when finished
  void _isDownloadingIndicator() {
    _downloadController.isDownloading.listen(
      (isDownloading) {
        if (isDownloading) {
          Get.dialog(
            Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  color: Colors.black,
                ),
              ),
            ),
            barrierDismissible: false,
          );
        } else {
          if (Get.isDialogOpen) {
            Get.back(closeOverlays: true);
          }
        }
      },
    );
  }

  void signOut() async {
    if (await _auth.isLoggedIn()) {
      _auth.signOutUser();
      Get.offAndToNamed(LogInScreen.id);
    } else {
      Get.snackbar('Ocorreu um erro inesperado!', _auth.authErrorCode);
    }
  }

  @override
  void onInit() {
    _auth = Get.find<Auth>();
    _db = Get.find<Database>();
    _storage = Get.find<Storage>();
    _downloadController = Get.find<DownloadController>();
    drawerKey = GlobalKey<SliderMenuContainerState>();
    getProjectsData();
    _isDownloadingIndicator();
    super.onInit();
  }

  @override
  void onClose() {}

  static HomeController get to => Get.find();
}
