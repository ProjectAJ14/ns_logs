import 'dart:async';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:ns_logs/ns_logs.dart';

import '../utils/map_extension.dart';

final Map<String, dynamic> _noInternetResponse = {
  APIKeys.statusCode: APIStatusCode.noInternet,
  APIKeys.message: "No Internet"
};

const bool _logResponse = false;

const Map<String, dynamic> emptyResponse = <String, dynamic>{};

const Map<String, dynamic> defaultMapHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

Response _defaultResponseTimeout(String path) {
  return Response(
    requestOptions: RequestOptions(path: path),
    statusMessage: 'Time out',
  );
}

Response _defaultResponseError(String path, {dynamic error}) {
  return Response(
    requestOptions: RequestOptions(path: path),
    statusMessage: 'Something went wrong',
    data: {'error': '$error'},
  );
}

///
class AppAPI {
  AppAPI._();

  /// Request headers
  static Map<String, dynamic> get authRequestHeaders => nsLog.headers;

  /// Instance of dio
  static Dio _dio = Dio();

  /// setBaseURL
  static void setBaseURL(String baseurl) {
    appLogs(
      "AppAPI setBaseURL : ${nsLog.baseUrl},",
    );
    _dio = Dio(
      BaseOptions(baseUrl: nsLog.baseUrl),
    );
  }

  /// Get API call
  static Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
    bool logResponse = _logResponse,
    bool checkForInternet = true,
    bool useFullPath = false,
  }) async {
    if (!await ConnectivityWrapper.instance.isConnected && checkForInternet) {
      return _noInternetResponse;
    }

    if (logResponse) {
      apiLogs('[GET] $path');
    }

    var errorFlag = false;
    var timeOutFlag = false;
    Map<String, dynamic> responseData = <String, dynamic>{};
    var stopWatch = Stopwatch()..start();

    try {
      var response = await _dio.get(
        useFullPath ? path : Uri.encodeFull(path),
        options: Options(
          headers: headers ?? authRequestHeaders,
          validateStatus: (status) {
            return status! < APIStatusCode.maxServerErrorCode;
          },
        ),
        onReceiveProgress: (
          int count,
          int total,
        ) {
          onReceiveProgress != null
              ? onReceiveProgress(count, total)
              : _onReceiveProgress(count, total, path: path);
        },
      ).catchError((onError) {
        responseData.putIfAbsent(APIKeys.errorDetails, () => '$onError');
        errorFlag = true;
        return _defaultResponseError(path, error: onError);
      }).timeout(
        const Duration(seconds: APIStatusCode.timeoutDuration),
        onTimeout: () async {
          timeOutFlag = true;
          return _defaultResponseTimeout(path);
        },
      );
      responseData = await parseDioResponse(
            response,
            path: path,
            errorFlag: errorFlag,
            timeOutFlag: timeOutFlag,
          ) ??
          emptyResponse;
    } catch (e, s) {
      errorLogs('${_dio.options.baseUrl}$path has exception', e, s);
      responseData.putIfAbsent(
        APIKeys.statusCode,
        () => APIStatusCode.errorStatusCode,
      );
      responseData.putIfAbsent(APIKeys.exception, () => '$e \n $s');
    }

    stopWatch.stop();

    DevAPIService.instance.insertAPICall(
      AppAPIsCall(
        id: DateTime.now().toIso8601String(),
        type: 'GET',
        path: path,
        dateTime: DateTime.now(),
        data: {},
        response: responseData,
        duration: stopWatch.elapsed,
      ),
    );

    if (logResponse) {
      apiLogs(
        '[GET][${responseData.getInt(APIKeys.statusCode)}] $path',
        responseData.toPretty(),
      );
    }

    return responseData;
  }

  /// POST API call
  static Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    FormData? formData,
    ProgressCallback? onReceiveProgress,
    bool logResponse = _logResponse,
    bool checkForInternet = true,
  }) async {
    if (!await ConnectivityWrapper.instance.isConnected && checkForInternet) {
      return _noInternetResponse;
    }
    if (logResponse) {
      apiLogs(
        '[POST] $path ${data?.toPretty()}'
        '${formData?.fields.map((e) => '${e.key}:${e.value}').toList()}',
      );
    }
    var errorFlag = false;
    var timeOutFlag = false;
    Map<String, dynamic> responseData = emptyResponse;
    var stopWatch = Stopwatch()..start();

    try {
      var response = await _dio.post(
        Uri.encodeFull(path),
        data: data ?? formData,
        options: Options(
          headers: headers ?? authRequestHeaders,
          validateStatus: (status) {
            return status! < APIStatusCode.maxServerErrorCode;
          },
        ),
        onReceiveProgress: (
          int count,
          int total,
        ) {
          onReceiveProgress != null
              ? onReceiveProgress(count, total)
              : _onReceiveProgress(count, total, path: path);
        },
      ).catchError((onError) {
        // responseData.putIfAbsent(APIKeys.errorDetails, () => '$onError');
        errorLogs(onError);
        errorFlag = true;
        return _defaultResponseError(path);
      }).timeout(
        const Duration(seconds: APIStatusCode.timeoutDuration),
        onTimeout: () async {
          timeOutFlag = true;
          return _defaultResponseTimeout(path);
        },
      );
      // var response = await Dio().post(
      //   App.instance.appConfig.baseUrlConfig.baseUrl + path,
      //   data: data,
      // ).catchError((onError) {
      //   errorLogs(onError);
      //   errorFlag = true;
      //   return null;
      // });
      responseData = (await parseDioResponse(
            response,
            path: path,
            errorFlag: errorFlag,
            timeOutFlag: timeOutFlag,
          )) ??
          emptyResponse;
    } catch (e, s) {
      errorLogs('${_dio.options.baseUrl}$path has exception', e, s);
      responseData.putIfAbsent(
        APIKeys.statusCode,
        () => APIStatusCode.errorStatusCode,
      );
      responseData.putIfAbsent(APIKeys.exception, () => '$e \n $s');
    }

    stopWatch.stop();

    DevAPIService.instance.insertAPICall(
      AppAPIsCall(
        id: DateTime.now().toIso8601String(),
        type: 'POST',
        path: path,
        dateTime: DateTime.now(),
        data: data,
        response: responseData,
        duration: stopWatch.elapsed,
      ),
    );

    if (logResponse) {
      apiLogs(
        '[POST][${responseData.getInt(APIKeys.statusCode)}] $path',
        responseData.toPretty(),
      );
    }

    return responseData;
  }

  /// PUT API call
  static Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
    ProgressCallback? onReceiveProgress,
    bool logResponse = _logResponse,
    bool checkForInternet = true,
  }) async {
    if (!await ConnectivityWrapper.instance.isConnected && checkForInternet) {
      return _noInternetResponse;
    }
    if (logResponse) {
      apiLogs(
        '[PUT] $path ${data?.toPretty()}'
        '${formData?.fields.map((e) => '${e.key}:${e.value}').toList()}',
      );
    }

    var errorFlag = false;
    var timeOutFlag = false;
    Map<String, dynamic> responseData = <String, dynamic>{};
    var stopWatch = Stopwatch()..start();

    try {
      var response = await _dio.put(
        Uri.encodeFull(path),
        data: data ?? formData,
        options: Options(
          headers: authRequestHeaders,
          validateStatus: (status) {
            return status! < APIStatusCode.maxServerErrorCode;
          },
        ),
        onReceiveProgress: (
          int count,
          int total,
        ) {
          onReceiveProgress != null
              ? onReceiveProgress(count, total)
              : _onReceiveProgress(count, total, path: path);
        },
      ).catchError((onError) {
        responseData.putIfAbsent(APIKeys.errorDetails, () => '$onError');
        errorFlag = true;
        return _defaultResponseError(path);
      }).timeout(
        const Duration(seconds: APIStatusCode.timeoutDuration),
        onTimeout: () async {
          timeOutFlag = true;
          return _defaultResponseTimeout(path);
        },
      );
      responseData = await parseDioResponse(
            response,
            path: path,
            errorFlag: errorFlag,
            timeOutFlag: timeOutFlag,
          ) ??
          emptyResponse;
    } catch (e, s) {
      errorLogs('${_dio.options.baseUrl}$path has exception', e, s);
      responseData.putIfAbsent(
        APIKeys.statusCode,
        () => APIStatusCode.errorStatusCode,
      );
      responseData.putIfAbsent(APIKeys.exception, () => '$e \n $s');
    }
    stopWatch.stop();

    DevAPIService.instance.insertAPICall(
      AppAPIsCall(
        id: DateTime.now().toIso8601String(),
        type: 'PUT',
        path: path,
        dateTime: DateTime.now(),
        data: data ?? {},
        response: responseData,
        duration: stopWatch.elapsed,
      ),
    );

    if (logResponse) {
      apiLogs(
        '[PUT][${responseData.getInt(APIKeys.statusCode)}] $path',
        responseData.toPretty(),
      );
    }

    return responseData;
  }

  /// DELETE API call
  static Future<Map<String, dynamic>> delete(
    String path, {
    ProgressCallback? onReceiveProgress,
    bool logResponse = _logResponse,
    bool checkForInternet = true,
  }) async {
    if (!await ConnectivityWrapper.instance.isConnected && checkForInternet) {
      return _noInternetResponse;
    }
    if (logResponse) {
      apiLogs('[DELETE] $path');
    }

    var errorFlag = false;
    var timeOutFlag = false;
    Map<String, dynamic> responseData = <String, dynamic>{};
    var stopWatch = Stopwatch()..start();

    try {
      var response = await _dio
          .delete(
        Uri.encodeFull(path),
        options: Options(
          headers: authRequestHeaders,
          validateStatus: (status) {
            return status! < APIStatusCode.maxServerErrorCode;
          },
        ),
      )
          .catchError((onError) {
        responseData.putIfAbsent(APIKeys.errorDetails, () => '$onError');
        errorFlag = true;
        return _defaultResponseError(path);
      }).timeout(
        const Duration(seconds: APIStatusCode.timeoutDuration),
        onTimeout: () async {
          timeOutFlag = true;
          return _defaultResponseTimeout(path);
        },
      );
      responseData = await parseDioResponse(
            response,
            path: path,
            errorFlag: errorFlag,
            timeOutFlag: timeOutFlag,
          ) ??
          emptyResponse;
    } catch (e, s) {
      errorLogs('${_dio.options.baseUrl}$path has exception', e, s);
      responseData.putIfAbsent(
        APIKeys.statusCode,
        () => APIStatusCode.errorStatusCode,
      );
      responseData.putIfAbsent(APIKeys.exception, () => '$e \n $s');
    }

    stopWatch.stop();

    DevAPIService.instance.insertAPICall(
      AppAPIsCall(
        id: DateTime.now().toIso8601String(),
        type: 'DELETE',
        path: path,
        dateTime: DateTime.now(),
        data: {},
        response: responseData,
        duration: stopWatch.elapsed,
      ),
    );

    if (logResponse) {
      apiLogs(
        '[DELETE][${responseData.getInt(APIKeys.statusCode)}] $path',
        responseData.toPretty(),
      );
    }

    return responseData;
  }

  static Future<Map<String, dynamic>?> parseDioResponse(
    Response response, {
    String? path,
    bool errorFlag = false,
    bool timeOutFlag = false,
  }) async {
    Map<String, dynamic> responseData = <String, dynamic>{};

    if (timeOutFlag) {
      responseData.putIfAbsent(
        APIKeys.statusCode,
        () => APIStatusCode.timeOutCode,
      );
      responseData.putIfAbsent(
        APIKeys.message,
        () => APIMessages.timeoutMessage,
      );
    } else if (errorFlag) {
      responseData.putIfAbsent(
        APIKeys.statusCode,
        () => APIStatusCode.errorStatusCode,
      );
      responseData.putIfAbsent(
        APIKeys.message,
        () => APIMessages.defaultErrorMessage,
      );
      responseData.putIfAbsent(APIKeys.data, () => response.data);
    } else {
      if (response.data is Map) {
        responseData = response.data;
      } else {
        responseData.putIfAbsent(APIKeys.data, () => response.data);
      }
      responseData.putIfAbsent(APIKeys.statusCode, () => response.statusCode);
    }
    var statusCode = responseData.getInt(APIKeys.statusCode);
    if (statusCode >= APIStatusCode.badRequest) {
      errorLogs(
        '[$statusCode] $path',
        '',
        StackTrace.fromString(responseData.toPretty()),
      );
    } else {
      appLogs('[$statusCode] ${_dio.options.baseUrl}$path');
    }

    //TO DEBUG requestHeaders
    // appLogs('[$path]requestHeaders:${requestHeaders.toPretty()}');

    return responseData;
  }

  static _onReceiveProgress(
    int count,
    int total, {
    String? path,
  }) {
    if (total > count) {
      // apiLogs("${_dio.options.baseUrl}$path "
      //     "onReceiveProgress $count $total "
      //     " ${(count / total * 100).toInt()} % ");
    }
  }
}
