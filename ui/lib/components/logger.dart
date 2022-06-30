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
    if (platform == null) {
      warning("Platform hasn't been initialised, unable to log to server");
      return;
    }
    try {
      platform.serverLog(s, (error) => warning('Unable to log to server, error was $error'));
    } on NoSuchMethodError catch (_) {
      warning("Unable to log to server, platform doesn't support server logging");
    } catch (e) {
      warning('Unable to log to server, error was $e');
    }
  }

  void _log(String s) {
    print("${DateTime.now().toIso8601String()} $name: $s");
  }
}
