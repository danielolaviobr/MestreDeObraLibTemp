import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:mestre_de_obra/Controllers/HomeControllers/DownloadController.dart';
import 'package:mestre_de_obra/Controllers/HomeControllers/HomeControllers.dart';
import 'package:mestre_de_obra/Models/auth.dart';
import 'package:mestre_de_obra/Models/database.dart';
import 'package:mestre_de_obra/Models/storage.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DownloadController>(() => DownloadController());
    Get.lazyPut<Database>(() => Database());
    Get.lazyPut<Storage>(() => Storage());
    Get.lazyPut<Auth>(() => Auth());
  }
}
