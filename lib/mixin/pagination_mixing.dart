import 'package:get/get.dart';
import 'package:helper/data/enums/request_type.dart';
import 'package:helper/utility/base_client.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart' as dio;

mixin PaginationMixin<T> {
  RxBool isLoadMore = RxBool(false);
  RxBool isFinish = RxBool(false);
  RxBool isLoadPaginationData = RxBool(false);
  String? paginationUrl;
  RxList<T> paginationData = RxList([]);
  bool isFirstPage = false;
  String? nextPageUrl;

  Map<String, dynamic> paginationParameter = {};

  /// find the next url from response
  String? getNextPageUrlFrom(Map<String, dynamic> json);

  List<T> getModelFromPaginationJsonUsing(Map<String, dynamic> json);

  void onPaginationError(Object e) {}

  void setPaginationData(Map<String, dynamic> data) {
    String? urlDAta = getNextPageUrlFrom(data);

    /// [getNextUrlForPaginationUsing] return null if current page is last page else return next page url  or not used

    nextPageUrl = urlDAta;
    if (nextPageUrl != null) {
      String parameterAsString = "";
      paginationParameter.forEach((key, value) {
        parameterAsString += "$key=$value&&";
      });
      parameterAsString.substring(0, parameterAsString.length - 2);
      nextPageUrl = "$nextPageUrl&&$parameterAsString";
    }
  }

  void setData(Map<String, dynamic>? mapData, bool isRefresh) {
    if (mapData != null) {
      try {
        if (isRefresh) {
          paginationData.clear();
          paginationData.value = getModelFromPaginationJsonUsing(mapData);
        } else {
          //load data
          paginationData.addAll(getModelFromPaginationJsonUsing(mapData));
        }
      } catch (e, s) {
        Logger().e("$e, $s");
        onPaginationError(e);
      }
    }
  }

  Future getPaginationData({
    required bool isRefresh,
    Function? onSuccess,
    Function? onError,
  }) async {
    if (paginationUrl == null) {
      String message =
          "[helper] : pleas assign url in onInit function in controller (^._.^)  ";
      throw Exception(message);
    }
    if (isRefresh) {
      //break loop get data from api page 1, 2 ,3, 4 , ... 1, 2, 3,
      nextPageUrl = null;
      isFirstPage = true;
      isLoadMore.value = false;
    }

    //get fresh data now
    if (nextPageUrl == null && !isLoadPaginationData.value && isFirstPage) {
      isLoadPaginationData.value = true;
      try {
        String url = "$paginationUrl";
        if (paginationParameter.isNotEmpty) {
          url = "$paginationUrl?";
          paginationParameter.forEach((key, value) {
            url += "$key=$value&&";
          });
          // remove && from url
          url = url.substring(0, url.length - 2);
          // Logger().i(url);
        }
        dio.Response? response = await BaseClient.apiCall(
            url: url,
            type: "Pagination",
            requestType: RequestType.get,
            onSuccess: (res, ty) {
              onSuccess?.call();
            });
        isLoadPaginationData.value = false;
        setData(response!.data, isRefresh);
        setPaginationData(response.data);
      } catch (e) {
        onError?.call();
      }
      isLoadPaginationData.value = false;
      isFirstPage = false;
    } else {
      if (nextPageUrl != null && !isLoadMore.value) {
        isFinish.value = false;
        isLoadMore.value = true;
        try {
          dio.Response? response = await BaseClient.apiCall(
              url: nextPageUrl!,
              type: "Pagination",
              requestType: RequestType.get,
              onSuccess: (res, ty) {
                onSuccess?.call();
              });
          isLoadMore.value = false;
          setData(response!.data, isRefresh);
          setPaginationData(response.data);
        } catch (e) {
          onError?.call();
        }
        isLoadMore.value = false;
        isFirstPage = false;
      } else {
        isFinish.value = true;
      }
    }
  }
}
