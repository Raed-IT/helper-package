import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helper/widgets/loading_button_widget/loading_button_widget.dart';
import 'package:helper_example/app/home/home_controller.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HelperLoadingButtonWidget(
            onTap: () async {
              await Future.delayed(Duration(seconds: 1));
            },
            label: 'test',
          )
        ],
      ),
    );
  }
}
