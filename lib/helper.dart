import 'package:helper/data/models/dio_config_model.dart';

import 'data/constant.dart';

export 'package:helper/data/enums/request_type.dart';
export 'package:helper/data/enums/api_call_status.dart';
export 'package:helper/utility/base_client.dart';

class Helper {
  static void initial(
      {String? appName, String local = "ar", ApiConfig? apiConfig}) {
    HelperConstant.instance;
    HelperConstant.local = local;
    HelperConstant.apiConfig = apiConfig ?? ApiConfig.printResponse();
  }
}
