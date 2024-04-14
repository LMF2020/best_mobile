import 'dart:async';
import 'dart:io';

import 'package:flutter_logs/flutter_logs.dart';
import 'package:intl/intl.dart';
import 'package:sparkmob/api/http_api.dart';
import 'package:sparkmob/controller/main_controller.dart';
import 'package:sparkmob/model/deviceInfo.dart';
import 'package:sparkmob/utils/app_const.dart';

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

  static clearTimer() {
    Timer? timer = APP.currentTimer;
    if (timer != null) {
      timer.cancel();
    }
  }

  // 创建一个timer 每分钟检查一次设备绑定情况
  static void createDeviceCheckTimer({
    required MainController controller,
    required HttpsAPI api,
  }) {
    clearTimer();
    // 创建timer
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      APP.currentTimer = timer;
      try {
        bool isLoggedIn = controller.isLoggedIn.value;
        bool isTokenAlive = controller.isTokenExist();
        String userId = controller.mainState.loginUser.value.id ?? "";
        if (!isLoggedIn ||
            !isTokenAlive ||
            userId.isEmpty ||
            APP.deviceId == null) {
          return; // 没有登陆
        }
        // 登陆状态下更新缓存，使其保持登陆状态
        DeviceInfo deviceInfo = await api.loadDeviceInfo(
            userId: userId, keepLogin: true, needLogout: false);
        print(
          "[CheckDeviceTimer] Keep Login: User:$userId === ${timer.tick}",
        );
        // 请求查询到其他设备登陆 取消定时任务
        if (deviceInfo.deviceId != "" && deviceInfo.deviceId != APP.deviceId) {
          timer.cancel();
          APP.currentTimer = null;
          FlutterLogs.logInfo(
              "[CheckDeviceTimer]", "Lose Login Connection", "User:$userId");
        }
      } catch (e) {
        print("checkDeviceLogin error $e");
      }
    });
  }
}
