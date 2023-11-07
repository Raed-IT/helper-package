import 'dart:ffi';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:helper/data/models/url_model.dart';
import 'package:helper/helper.dart';
import 'package:helper/utility/api_exceptions.dart';
import 'package:logger/logger.dart';

mixin ApiHelperMixin {
  /// [urls] list of url provided from user ..
  List<UrlModel> urls = [];

  ///[isLoadData] list of RxBool provided from package as {type_url , status}
  Rx<Map<String, RxBool>> isLodData = Rx({});
  Rx<Map<String, ApiCallStatus>> statusLodData = Rx({});

  ///[isLoad] indicated for all status requests any request it tack true status
  RxBool isLoad = RxBool(false);

  ///

  /// available functions
  ///
  /// set data from api to controller
  getDataFromJson({required Map<String, dynamic> json, String? type}) {}

  /// on any error set error and url type
  onErrorApi(ApiException exception, String type) {}

  /// get single request from url type
  getSingleData({required UrlModel url, Map<String, dynamic>? headers}) async {
    isLoad.value = true;
    isLodData.value[url.type]?.value = true;
    BaseClient.safeApiCall(
      type: url.type,
      headers: headers,
      onError: (ApiException exception, String type) {
        statusLodData.value[type] = ApiCallStatus.error;
        isLodData.value[type]?.value = false;
        onErrorApi(exception, type);
        _checkLoad();
      },
      queryParameters: url.parameter,
      onSuccess: (re, type) {
        try {
          getDataFromJson(json: re.data, type: url.type);
          statusLodData.value[type] = ApiCallStatus.success;
          isLodData.value[type]?.value = false;
          _checkLoad();
        } catch (e, s) {
          Logger().i(s);
        }
      },
      url: url.url,
      requestType: RequestType.get,
    );
  }

  /// get all requests
  Future<void> getData({Map<String, dynamic>? headers}) async {
    /// starting get data
    ///
    isLoad = RxBool(true);
    for (var element in urls) {
      isLodData.value[element.type] = RxBool(true);
    }
    for (var element in urls) {
      statusLodData.value[element.type] = ApiCallStatus.loading;
    }
    for (UrlModel url in urls) {
      BaseClient.safeApiCall(
        type: url.type,
        headers: headers,
        onError: (ApiException exception, String type) {
          statusLodData.value[type] = ApiCallStatus.error;
          isLodData.value[type]?.value = false;
          onErrorApi(exception, type);
          _checkLoad();
        },
        queryParameters: url.parameter,
        onSuccess: (re, type) {
          try {
            getDataFromJson(json: re.data, type: url.type);
            statusLodData.value[type] = ApiCallStatus.success;
            isLodData.value[type]?.value = false;
            _checkLoad();
          } catch (e, s) {
            Logger().e(s);
          }
        },
        url: url.url,
        requestType: RequestType.get,
      );
    }
  }

  void _checkLoad() {
    bool isFinish = true;
    isLodData.value.forEach((key, value) {
      if (isLodData.value[key]!.value) {
        isFinish = false;
      }
    });
    isLoad.value = !isFinish;
  }
}
