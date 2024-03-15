import 'package:get/get.dart';
import 'package:helper/data/enums/request_type.dart';
import 'package:helper/utility/base_client.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart' as dio;

mixin PaginationMixin<T> {
  RxBool isLoadMore = RxBool(false);
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
    // } else {
    // data = data['data'];
    // if (data.containsKey("pagination")) {
    //   nextPageUrl = data["pagination"]['next_page_url'];
    //   // total.value = data["pagination"]['total'];
    // }
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
    if (nextPageUrl == null && !isLoadMore.value && isFirstPage) {
      isLoadMore.value = true;
      try {
        dio.Response? response = await BaseClient.apiCall(
            url: paginationUrl!,
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
    }
    isLoadMore.value = false;
  }
}
