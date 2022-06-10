import 'package:dio/dio.dart';
import 'package:ns_logs/ns_logs.dart';

class LoggingInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    apiLogs("API REQUEST", options);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);

    AppAPIsCall apiCall = AppAPIsCall(
      id: DateTime.now().toIso8601String(),
      type: response.requestOptions.method,
      path: response.requestOptions.path,
      dateTime: DateTime.now(),
      data: response.requestOptions.data,
      response: response.data,
      statusCode: response.statusCode ?? 0,
      duration: Duration(milliseconds: response.requestOptions.receiveTimeout),
    );
    DevAPIService.instance.insertAPICall(apiCall);
    if (nsLog.logTypes.contains(AppLogTag.api)) {
      apiLogs("API LOG", apiCall.toString());
    }
  }
}
