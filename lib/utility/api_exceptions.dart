import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String url;
  final String message;
  final int? statusCode;
  final Response? response;

  ApiException({
    required this.url,
    required this.message,
    this.response,
    this.statusCode,
  });

  @override
  toString() {
    String result = '';

    // todo add error message field which is coming from api for you (For ex: response.data['error']['message']
    result += response?.data?['error'] ?? '';

    if (result.isEmpty) {
      result +=
          message; // message is the (dio error message) so usualy its not user friendly
    }

    return result;
  }
}
