enum LogLevel { ERROR, WARNING, DEBUG, VERBOSE }

class Logger {
  String name;

  static LogLevel logLevel = LogLevel.VERBOSE;
  static dynamic platform;

  Logger(this.name);

  void error(String s) {
    _log(s);
  }

  void warning(String s) {
    switch (logLevel) {
      case LogLevel.ERROR:
        return;
      default:
        _log(s);
    }
  }

  void debug(String s) {
    switch (logLevel) {
      case LogLevel.WARNING:
      case LogLevel.ERROR:
        return;
      default:
        _log(s);
    }
  }

  void verbose(String s) {
    switch (logLevel) {
      case LogLevel.DEBUG:
      case LogLevel.WARNING:
      case LogLevel.ERROR:
        return;
      default:
        _log(s);
    }
  }

  void serverLog(String s) {
    debug(s);
    if (platform != null) {
      platform.serverLog(s, (error) => warning('Unable to log to server, error was $error'));
    } else {
      warning('Platform hasn\'t been initialised, unable to log to server');
    }
  }

  void _log(String s) {
    print("${DateTime.now().toIso8601String()} $name: $s");
  }
}
