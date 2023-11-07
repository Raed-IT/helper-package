import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helper_example/app/test/test_controller.dart';

class TestScreen extends GetView<TestScreenController> {
  TestScreen({super.key});

  TextStyle style = TextStyle(fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => Text(
              "sections => ${controller.isLodData.value['sections']}     ==> ${controller.statusLodData.value['sections']}",
              style: style)),
          Obx(() => Text(
              "sliders => ${controller.isLodData.value['sliders']}    ==> ${controller.statusLodData.value['sliders']}",
              style: style)),
          Obx(() => Text("isLoad => ${controller.isLoad}", style: style)),
          MaterialButton(
            onPressed: () => controller.getSingleData(url: controller.urls[1]),
            child: Text("sdsd"),
          )
        ],
      ),
    );
  }
}
