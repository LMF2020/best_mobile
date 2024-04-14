import 'dart:io';

import 'package:intl/intl.dart';

class Utils {
  /// 把utc时间转化为本地时区的时间和格式
  static String formatDateTimeToYYYYMMDD(
      String utcTime, String timeZone, String targetFormat) {
    if (utcTime == "") {
      return "";
    }
    var locale = timeZone == 'Asia/Shanghai' ? 'zh' : 'en';
    DateTime? dt = formatStringToDateTime(utcTime);
    String localTZ = formatDateTimeLocal(dt!, locale);
    if (targetFormat == 'HH:mm') {
      return localTZ.substring("yyyy-MM-dd".length + 1);
    }
    return localTZ.substring(0, "yyyy-MM-dd".length);
  }

  /// duration 转换为 DateTime
  static DateTime formatMinutesToDuration(int minutes) {
    var now = DateTime(0, 0, 0, 0);
    return now.add(Duration(minutes: minutes));
  }

  /// DateTime转换为 duration
  static int getDuration(DateTime dateTime) {
    return dateTime.hour * 60 + dateTime.minute;
  }

  static bool isNumeric(String str) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(str);
  }

  /// DateTime 转换为 string 传给后台
  static String formatDateTimeToString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'').format(dateTime);
  }

  /// string 转换为 DateTime的UTC时间 -- 后台获取meeting的start time均为utc时间
  static DateTime? formatStringToDateTime(String timeString) {
    if (timeString == "") {
      return null;
    }
    return DateTime.parse(timeString);
  }

  /// 组件显示在日期栏
  static String formatDateTimeLocal(DateTime dateTime, String locale) {
    if (locale == 'zh') {
      return DateFormat('yyyy-MM-dd a HH时mm分', locale).format(dateTime);
    }
    return DateFormat('yyyy-MM-dd a HH:mm', locale).format(dateTime);
  }

  /// 组件显示时长 (3小时 60 分)
  static String formatTimeLocal(DateTime dateTime, String locale) {
    if (locale == 'zh') {
      return '${dateTime.hour.toString()}小时 ${dateTime.minute.toString()}分钟';
    }
    return '${dateTime.hour.toString()}h ${dateTime.minute.toString()}m';
  }

  static bool validateInput(String? input) {
    if (input == null) {
      return false;
    }
    if (input.isEmpty) {
      return false;
    }
    return true;
  }

  static String getDeviceOS() {
    if (Platform.isAndroid) {
      return "android";
    }
    if (Platform.isIOS) {
      return "ios";
    }
    if (Platform.isLinux) {
      return "linux";
    }
    if (Platform.isMacOS) {
      return "macos";
    }
    return "unknow";
  }
}
