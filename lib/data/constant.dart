import 'package:helper/data/models/dio_config_model.dart';

class HelperConstant {
  HelperConstant._();

//single toon class
  static final HelperConstant instance = HelperConstant._();

  static const double fontSize = 15;
  static String? token;
  static String local = "ar";
  static ApiConfig apiConfig = ApiConfig.printResponse();
  static Map<String, dynamic> globalHeader = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };
}
