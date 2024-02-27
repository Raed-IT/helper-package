import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:helper/data/constant.dart';
import 'package:helper/data/enums/request_type.dart';
import 'package:helper/data/enums/strings_enum.dart';
import 'package:helper/data/strings.dart';
import 'package:helper/utility/api_exceptions.dart';
import 'package:helper/utility/toast.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

typedef OnSuccess = Function(Response response, String type);
typedef OnError = Function(ApiException, String type)?;
typedef OnReceiveProgress = Function(int value, int progress)?;
typedef OnSendProgress = Function(int total, int progress)?;

class BaseClient {
  static final Dio _dio = Dio(
    BaseOptions(headers: HelperConstant.globalHeader),
  )..interceptors.add(PrettyDioLogger(
      requestHeader: HelperConstant.apiConfig.requestHeader,
      requestBody: HelperConstant.apiConfig.requestBody,
      responseBody: HelperConstant.apiConfig.responseBody,
      responseHeader: HelperConstant.apiConfig.responseHeader,
      error: HelperConstant.apiConfig.error,
      compact: HelperConstant.apiConfig.compact,
      request: HelperConstant.apiConfig.request,
      maxWidth: 90,
    ));

  static const int _timeoutInSeconds = 15;

  /// dio getter (used for testing)
  static get dio => _dio;

  /// perform safe api request
  static Future apiCall({
    required String url,
    required String type,
    required RequestType requestType,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required OnSuccess onSuccess,
    OnError onError,
    OnReceiveProgress onReceiveProgress,
    OnSendProgress onSendProgress, // while sending (uploading) progress
    Function? onLoading,
    dynamic data,
  }) async {
    try {
      // 1) indicate loading state
      await onLoading?.call();
      // 2) try to perform http request
      late Response response;

      if (requestType == RequestType.get) {
        response = await _dio.get(
          url,
          onReceiveProgress: onReceiveProgress,
          queryParameters: queryParameters,
          options: Options(
            headers: headers,
          ),
        );
      } else if (requestType == RequestType.post) {
        response = await _dio.post(
          url,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      } else if (requestType == RequestType.put) {
        response = await _dio.put(
          url,
          data: data,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      } else {
        response = await _dio.delete(
          url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers),
        );
      }
      // 3) return response (api done successfully)
      await onSuccess(response, type);
    } on DioException catch (error) {
      // dio error (api reach the server but not performed successfully
      _handleDioError(
          error: error,
          url: url,
          onError: (ex) {
            if (onError != null) {
              onError(ex, type);
            }
          });
      Exception(error);
    } on SocketException {
      // No internet connection
      _handleSocketException(
          url: url,
          onError: (ex) {
            if (onError != null) {
              onError(ex, type);
            }
          });
      Exception("helper socket exception $url");
    } on TimeoutException {
      // Api call went out of time
      _handleTimeoutException(
          url: url,
          onError: (ex) {
            if (onError != null) {
              onError(ex, type);
            }
          });
      Exception("helper time out  exception $url");
    } catch (error, stackTrace) {
      // print the line of code that throw unexpected exception
      Logger().f(stackTrace);
      // unexpected error for example (parsing json error)
      _handleUnexpectedException(
          url: url,
          onError: (ex) {
            if (onError != null) {
              onError(ex, type);
            }
          },
          error: error);
      Exception(error);
    }
  }

  /// download file
  static download(
      {required String url, // file url
      required String savePath, // where to save file
      Function(ApiException)? onError,
      Function(int value, int progress)? onReceiveProgress,
      required Function onSuccess}) async {
    try {
      await _dio.download(
        url,
        savePath,
        options: Options(
            receiveTimeout: const Duration(seconds: _timeoutInSeconds),
            sendTimeout: const Duration(seconds: _timeoutInSeconds)),
        onReceiveProgress: onReceiveProgress,
      );
      onSuccess();
    } catch (error) {
      var exception = ApiException(url: url, message: error.toString());
      onError?.call(exception) ?? _handleError(error.toString());
    }
  }

  /// handle unexpected error
  static _handleUnexpectedException(
      {Function(ApiException)? onError,
      required String url,
      required Object error}) {
    if (onError != null) {
      onError(ApiException(
        message: error.toString(),
        url: url,
      ));
    }
    // else {
    _handleError(error.toString());
    // }
  }

  /// handle timeout exception
  static _handleTimeoutException(
      {Function(ApiException)? onError, required String url}) {
    if (onError != null) {
      onError(ApiException(
        message: Strings.fromLocal().get(key: StringsEnum.serverNotResponding),
        url: url,
      ));
    }
    // else {
    _handleError(Strings.fromLocal().get(key: StringsEnum.serverNotResponding));
    // }
  }

  /// handle timeout exception
  static _handleSocketException(
      {Function(ApiException)? onError, required String url}) {
    if (onError != null) {
      onError(
        ApiException(
          message:
              Strings.fromLocal().get(key: StringsEnum.noInternetConnection),
          url: url,
        ),
      );
    }
    // else {
    _handleError(
        Strings.fromLocal().get(key: StringsEnum.noInternetConnection));
    // }
  }

  /// handle Dio error
  static _handleDioError(
      {required DioException error,
      Function(ApiException)? onError,
      required String url}) {
    // 404 error
    if (error.response?.statusCode == 404) {
      if (onError != null) {
        onError(ApiException(
          message: Strings.fromLocal().get(key: StringsEnum.urlNotFound),
          url: url,
          statusCode: 404,
        ));
      }

      return _handleError(
          Strings.fromLocal().get(key: StringsEnum.urlNotFound));

    }

    // no internet connection
    if (error.message != null &&
        error.message!.toLowerCase().contains('socket')) {
      if (onError != null) {
          onError(ApiException(
          message:
              Strings.fromLocal().get(key: StringsEnum.noInternetConnection),
          url: url,
        ));
      }
      // else {
      return _handleError(
          Strings.fromLocal().get(key: StringsEnum.noInternetConnection));
      // }
    }

    // check if the error is 500 (server problem)
    if (error.response?.statusCode == 500) {
      var exception = ApiException(
        message: Strings.fromLocal().get(key: StringsEnum.serverError),
        url: url,
        statusCode: 500,
      );

      if (onError != null) {
         onError(exception);
      }
      // else {
      return handleApiError(exception);
      // }
    }

    var exception = ApiException(
        url: url,
        message: error.message ??
            Strings.fromLocal().get(key: StringsEnum.unExpectedApiError),
        response: error.response,
        statusCode: error.response?.statusCode);

    if (onError != null) {
      return onError(exception);
    }
    // else {
    return handleApiError(exception);
    // }
  }

  ///try to show the message from api
  static handleApiError(ApiException apiException) {
    String msg = apiException.toString();
    showHelperToast(message: msg);
  }

  /// handle errors without response (500, out of time, no internet,..etc)
  static _handleError(String msg) {
    showHelperToast(message: msg);
  }
}
