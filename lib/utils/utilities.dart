class Utilities {
  static String parseString(dynamic value) {
    try {
      if (value != null && value != "" && value != "null") {
        return value.toString();
      } else {
        return "";
      }
    } catch (ex) {
      return "";
    }
  }

  static bool parseBool(dynamic value, {bool defaultVal = false}) {
    try {
      switch (value.runtimeType) {
        case int:
          return value == 1;
        case String:
          return value.toLowerCase() == "true" || value.toLowerCase() == "1";
        case double:
          return value == 1.00;
        case bool:
          return value;
        default:
          return defaultVal;
      }
    } catch (ex) {
      return defaultVal;
    }
  }

  static int parseInt(dynamic value, {int defaultIntValue = 0}) {
    try {
      switch (value.runtimeType) {
        case int:
          return value;
          break;
        case double:
          return value.toInt();
          break;
        case String:
          return int.tryParse(value) ?? defaultIntValue;
          break;
        case num:
          return value.toInt();
          break;
        default:
          return defaultIntValue;
          break;
      }
    } catch (ex) {
      return defaultIntValue;
    }
  }

  static double parseDouble(dynamic value) {
    try {
      switch (value.runtimeType) {
        case int:
          return value.toDouble();
          break;
        case double:
          return value;
          break;
        case String:
          return double.parse(value);
          break;
        case num:
          return value.toDouble();
          break;
        default:
          return 0.0;
          break;
      }
    } catch (ex) {
      return 0.0;
    }
  }
}
