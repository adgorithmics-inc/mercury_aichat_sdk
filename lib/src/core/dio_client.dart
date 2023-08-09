import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart' as getx;
import 'package:mercury_aichat_sdk/src/core/utilities.dart';

class DioClient extends DioForNative {
  DioClient({BaseOptions? options}) : super(options) {
    interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) {
          return handler.next(e);
        },
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          getx.Get.log(
              'API ${response.requestOptions.method} ${response.realUri.path} ${response.statusCode}: '
              '${response.statusMessage}\n'
              '${VUtils.getPrettyJSONString(response.requestOptions.uri.queryParameters)}');
          return handler.next(response);
        },
      ),
    );
  }
}
