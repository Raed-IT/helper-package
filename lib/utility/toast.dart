import 'package:fluttertoast/fluttertoast.dart';
import 'package:helper/data/constant.dart';

void showHelperToast({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    fontSize: HelperConstant.fontSize,
  );
}
