import 'package:get/get.dart';
import 'package:helper_example/app/test/test_controller.dart';

class TestScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TestScreenController());
  }
}
