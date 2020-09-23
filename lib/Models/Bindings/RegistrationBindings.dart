import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:mestre_de_obra/Controllers/RegistrationControllers/RegistrationController.dart';
import 'package:mestre_de_obra/Models/auth.dart';
import 'package:mestre_de_obra/Models/database.dart';

class RegistrationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistrationController>(() => RegistrationController());
    Get.lazyPut<Database>(() => Database());
    Get.lazyPut<Auth>(() => Auth());
  }
}
