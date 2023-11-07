import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helper_example/app/home/home.dart';
import 'package:helper_example/app/home/home_binding.dart';
import 'package:helper_example/app/test/test.dart';
import 'package:helper_example/app/test/test_bining.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/home",
      getPages: [
        GetPage(
          name: "/home",
          page: () => HomeScreen(),
          binding: HomeScreenBinding(),
        ),
        GetPage(
          name: "/test",
          page: () => TestScreen(),
          binding: TestScreenBinding(),
        )
      ],
    );
  }
}
