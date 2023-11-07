import 'package:get/get.dart';
import 'package:helper/data/models/url_model.dart';
import 'package:helper/mixin/api_mixing.dart';

class TestScreenController extends GetxController with ApiHelperMixin {
  @override
  void onInit() {
    super.onInit();
    urls = [
      UrlModel(
        url: "https://ali-pasha.com/api/v1/sedctions",
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
  getDataFromJson({required Map<String, dynamic> json, String? type}) {
    print("type=====>>>>>$type");
  }
}
