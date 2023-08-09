import 'dart:convert';
import 'package:get/get.dart';

class VUtils {
  VUtils._();

  static String getPrettyJSONString(jsonObject) {
    if (jsonObject == null) return '';
    try {
      var encoder = const JsonEncoder.withIndent('     ');
      return encoder.convert(jsonObject);
    } catch (e) {
      Get.log(e.toString());
      return '';
    }
  }
}
