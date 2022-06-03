class APIStatusCode {
  static const int timeoutDuration = 30;

  static const int success = 200;

  static const int created = 201;

  static const int deleted = 204;

  static const int badRequest = 400;

  static const int unAuthorized = 401;

  static const int notFound = 404;

  static const int serverError = 500;

  static const int noInternet = 503;

  static const int timeOutCode = 504;

  static const int serverErrorCode = 600;

  static const int errorStatusCode = 999;

  static const int maxServerErrorCode = 9999;

  static const int timeoutDurationMilliseconds = 30000;
}

class APIKeys {
  static const String statusCode = "statusCode";
  static const String message = "message";
  static const String data = "data";
  static const String errorDetails = "error_details";
  static const String exception = "exception";
}

class APIMessages {
  static const String timeoutMessage = "Request timed out";
  static const String defaultErrorMessage = "Something went wrong";
}
