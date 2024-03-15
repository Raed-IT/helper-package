import 'package:get/get.dart';
import 'package:helper/data/models/url_model.dart';
import 'package:helper/helper.dart';
import 'package:helper/utility/api_exceptions.dart';
import 'package:logger/logger.dart';

mixin ApiHelperMixin {
  /// [urls] list of url provided from user ..
  List<UrlModel> urls = [];

  ///[isLodData] list of RxBool provided from package as {type_url , status}
  Rx<Map<String, RxBool>> isLodData = Rx({});
  Rx<Map<String, ApiCallStatus>> statusLodData = Rx({});

  ///[isLoad] indicated for all status requests any request it tack true status
  RxBool isLoad = RxBool(false);
  RxBool isPostData = RxBool(false);

  ///

  /// available functions
  ///
  /// set data from api to controller
  getDataFromJson({required Map<String, dynamic> json, String? type}) {}

  /// on any error set error and url type
  onErrorApi(ApiException exception, String type) {}

  /// get single request from url type
  getSingleData({
    required UrlModel url,
    Map<String, dynamic>? headers,
    bool isRespectIsLoad = true,
    Function()? onSuccess,
    Function()? onError,
  }) async {
    if (isRespectIsLoad) {
      isLoad.value = true;
    }
    statusLodData.value[url.type] = ApiCallStatus.loading;
    isLodData.value[url.type]?.value = true;

    BaseClient.apiCall(
      type: url.type,
      headers: headers,
      onError: (ApiException exception, String type) {
        if (onError != null) {
          onError();
        }
        statusLodData.value[type] = ApiCallStatus.error;
        isLodData.value[type]?.value = false;
        onErrorApi(exception, type);
        _checkLoad();
      },
      queryParameters: url.parameter,
      onSuccess: (re, type) {
        try {
          if (onSuccess != null) {
            onSuccess();
          }
          getDataFromJson(json: re.data, type: url.type);
          statusLodData.value[type] = ApiCallStatus.success;
          isLodData.value[type]?.value = false;
          _checkLoad();
        } catch (e, s) {
          Logger().e("Error $e \n stak tree  $s");
        }
      },
      url: url.url,
      requestType: RequestType.get,
    );
  }

  Future<void> getSingleDataWithSync({
    required UrlModel url,
    Map<String, dynamic>? headers,
    bool isRespectIsLoad = true,
    Function()? onSuccess,
    Function()? onError,
  }) async {
    if (isRespectIsLoad) {
      isLoad.value = true;
    }
    statusLodData.value[url.type] = ApiCallStatus.loading;
    isLodData.value[url.type]?.value = true;
    await BaseClient.apiCall(
      type: url.type,
      headers: headers,
      onError: (ApiException exception, String type) {
        if (onError != null) {
          onError();
        }
        statusLodData.value[type] = ApiCallStatus.error;
        isLodData.value[type]?.value = false;
        onErrorApi(exception, type);
        _checkLoad();
      },
      queryParameters: url.parameter,
      onSuccess: (re, type) {
        try {
          if (onSuccess != null) {
            onSuccess();
          }
          getDataFromJson(json: re.data, type: url.type);
          statusLodData.value[type] = ApiCallStatus.success;
          isLodData.value[type]?.value = false;
          _checkLoad();
        } catch (e, s) {
          Logger().e("Error $e \n stak tree  $s");
        }
      },
      url: url.url,
      requestType: RequestType.get,
    );
  }

  /// get all requests
  void getData({Map<String, dynamic>? headers}) {
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
      BaseClient.apiCall(
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

  Future postData({
    required String url,
    Function(int, int)? onReceiveProgress,
    required dynamic data,
    required OnSuccess onSuccess,
    required OnError onError,
    Map<String, dynamic>? headers,
    Function(int, int)? onSendProgress,
    Map<String, dynamic>? queryParameters,

    ///[requestType] for change from post request to put request
    RequestType requestType = RequestType.post,
  }) async {
    assert(requestType == RequestType.post || requestType == RequestType.put,
        "please provide  `requestType` post or put  your vale id $requestType");

    if (!isPostData.value) {
      isPostData.value = true;
      return await BaseClient.apiCall(
          url: url,
          type: 'post',
          requestType: requestType,
          onSuccess: (response, type) {
            isPostData.value = false;
            onSuccess(response, type);
          },
          onReceiveProgress: onReceiveProgress,
          data: data,
          headers: headers,
          onError: (exception, type) {
            isPostData.value = false;
            onErrorApi(exception, type);
            if (onError != null) {
              onError(exception, type);
            }
          },
          onSendProgress: onSendProgress,
          queryParameters: queryParameters);
    }
  }
}
