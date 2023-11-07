import 'package:helper/data/constant.dart';
import 'package:helper/data/enums/strings_enum.dart';

abstract class Strings {
  Strings();

  String get({required StringsEnum key});

  factory Strings.fromLocal({String? local}) {
    local ??= HelperConstant.local;
    switch (local) {
      case "ar":
        return StringsAr();
      default:
        return StringsEn();
    }
  }
}

class StringsAr extends Strings {
  Map<String, String> data = {
    "serverNotResponding": "الخادم لا يستجيب",
    "noInternetConnection": "لايوجد اتصال بالإنترنت",
    "urlNotFound": "لم يتم العثور على الطلب ",
    "serverError": "خطاء في الخادم اتصل بالدعم الفني",
    "unExpectedApiError":"خطأ غير متوقع في واجهة برمجة التطبيقات",
  };

  @override
  String get({required StringsEnum key}) {
    if (data.containsKey(key.name)) {
      return data[key.name]!;
    } else {
      return "not found key `${key.name}`";
    }
  }
}

class StringsEn extends Strings {
  Map<String, String> data = {
    "serverNotResponding": "Server Not Responding",
    "noInternetConnection": "No Internet Connection",
    "urlNotFound": "Url Not Found ",
    "serverError": "Server Error ",
    "unExpectedApiError":"Unexpected Api Error",

  };

  @override
  String get({required StringsEnum key}) {
    if (data.containsKey(key.name)) {
      return data[key.name]!;
    } else {
      return "not found key `${key.name}`";
    }
  }
}
