import 'package:get/get.dart';
import 'package:helper_example/app/home/home_controller.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeScreenController());
  }
}
