import 'package:get/get.dart';

import '../database.dart';

// TODO Create payment bindings
class PaymentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Database>(() => Database());
  }
}
