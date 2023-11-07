import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helper_example/app/home/home_controller.dart';

class HomeScreen extends GetView<HomeScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () => Get.toNamed("/test"),
          child: Text("go to test "),
        ),
      ),
    );
  }
}
