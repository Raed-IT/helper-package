import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:helper/data/models/url_model.dart';
import 'package:helper/mixin/api_mixing.dart';
import 'package:helper/utility/api_exceptions.dart';

class TestScreenController extends GetxController with ApiHelperMixin {
  @override
  void onInit() {
    super.onInit();
    urls = [
      UrlModel(
        url: "https://ali-pasha.com/api/v1/sections",
        type: "sections",
      ),
      UrlModel(
        url: "https://ali-pasha.com/api/v1/sliders",
        type: "sliders",
        parameter: {"type": "job"},
      ),
    ];
    getData();
  }

  @override
  onErrorApi(ApiException exception, String type) {
    print(exception.message);
  }

  @override
  getDataFromJson({required Map<String, dynamic> json, String? type}) {}
}
