//IGNORE FILE FOR REVIEW AS THIS IS FOR DEV

int get _maxTapCount => 3;

///
const int maxAPICount = 100;

/// DevAPIService Class
class DevAPIService {
  /// DevAPIService instance
  static DevAPIService instance = DevAPIService();

  int _count = 0;

  ///

  /// List of API calls
  List<AppAPIsCall> apiCalls = [];

  /// App signature
  String appSignature = '';

  /// increment count
  void incrementCount() {
    _count++;
  }

  /// reset count
  void resetCount() {
    _count = 0;
  }

  /// Insert API Call
  void insertAPICall(AppAPIsCall data) {
    apiCalls.insert(0, data);
    if (apiCalls.length >= maxAPICount) {
      apiCalls.removeLast();
    }
  }
}

/// APIS call model
class AppAPIsCall {
  /// id
  String id;

  /// type
  String type;

  /// path
  String path;

  /// date time
  DateTime dateTime;

  /// data
  Map<String?, dynamic>? data;

  /// response
  Map<String, dynamic>? response;

  ///
  Duration duration;

  /// AppAPIsCall Constructor
  AppAPIsCall({
    required this.id,
    required this.type,
    required this.path,
    required this.dateTime,
    required this.data,
    required this.response,
    required this.duration,
  });
}
