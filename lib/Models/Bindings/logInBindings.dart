import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:mestre_de_obra/Controllers/LogInControllers/LogInController.dart';

import '../auth.dart';

class LogInBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Auth>(() => Auth());
    Get.lazyPut<LogInController>(() => LogInController());
  }
}
