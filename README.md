# ns_logs

This package Contains

- Logs(Error, Warning, Repo, Info)
- APIs (Predefined Apis Structure Using Dio)
- Dev screens (Show API responses, log response and more)

## Getting Started

### 1. Logs

Logs will print log depends on log types. To how specific type of logs define it like this.

```dart
nsLog.setNSLog(
    logTypes: [AppLogTag.info,AppLogTag.warning,AppLogTag.error]
    );
```

LogTypes:
    info,
    api,
    error,
    warning,
    config

#### -> Log Usage

```dart
appLogs("This is Info Log");
repoLogs("This is Repo Log");
apiLogs("This is Api Log");
warnLogs("This is Warning Log");
configLogs("This is Config Log");
errorLogs("This is Error Log");
```

### 2. Apis

For calling api we are using Dio package. we can directly access apis without worrying about base url and other parsing functions. Also can add headers other parameters.

```dart
 nsLog.setBaseUrl(
    "https://www.helloworld.com",
    headers: {
         "accept": "application/json",
    },
  );
   nsLog.setBaseUrl(
    "https://www.helloworld.com",
    headers: {
        "accept": "application/json",
        "authorization": "bearer <TOKEN>",
    },
  );
```

#### -> Api Usage

```dart
Map<String, dynamic> response =  await AppAPI.get("/api/endpoint");

```
