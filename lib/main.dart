import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sparkmob/config/route_config.dart';
import 'package:sparkmob/utils/app_const.dart';
import 'package:sparkmob/utils/messages.dart';

import 'controller/main_binding.dart';
import 'controller/main_controller.dart';
import 'package:permission_handler/permission_handler.dart';

var _myLogFileName = "debugLog";

void main() async {
  // dio.interceptors.add(LogInterceptor());
  WidgetsFlutterBinding.ensureInitialized();
  PermissionStatus status = await Permission.bluetooth.request();

  await GetStorage.init();
  await setUpDeviceDetails();
  setUpLogs();

  if (status == PermissionStatus.granted) {
    print("Bluetooth permissions granted, proceed with Bluetooth operations.");
  } else {
    print("Bluetooth permissions denied, handle accordingly.");
  }
  // 解决白屏问题
  Future.delayed(const Duration(seconds: 2), () => runApp(const SparkApp()));
}

Future<String?> setUpDeviceDetails() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  const androidIdPlugin = AndroidId();
  try {
    if (Platform.isAndroid) {
      try {
        APP.deviceId = await androidIdPlugin.getId() ?? 'Unknown ID';
      } on PlatformException {
        print('OS: Failed to get Android ID.');
        return "";
      }
      print("OS: device UUID for Android ====== ${APP.deviceId}");
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      APP.deviceId = data.identifierForVendor;
      print(
          "OS: device UUID for IOS ====== ${APP.deviceId}  ,localModle: ${data.localizedModel}");

      // 获取系统的语言和区域设置
      // String language = data.localizedModel; // 例如 "en-US"
      // List<String> parts = language.split('_');
      // if (parts.length == 2) {
      //   currentLocale.value = Locale(parts[0], parts[1]);
      // }
    } else if (Platform.isLinux) {
      var data = await deviceInfoPlugin.linuxInfo;
      APP.deviceId = data.machineId;
      print("OS: device UUID for Linux ====== ${APP.deviceId}");
    } else if (Platform.isMacOS) {
      var data = await deviceInfoPlugin.macOsInfo;
      APP.deviceId = data.systemGUID;
      print("OS: device UUID for MacOS ====== ${APP.deviceId}");
    }
  } on PlatformException {
    print('OS: Failed to get device UUID');
  }
  return "";
}

void setUpLogs() async {
  await FlutterLogs.initLogs(
      logLevelsEnabled: [
        LogLevel.INFO,
        LogLevel.WARNING,
        LogLevel.ERROR,
        LogLevel.SEVERE
      ],
      timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
      directoryStructure: DirectoryStructure.FOR_DATE,
      logTypesEnabled: [_myLogFileName],
      logFileExtension: LogFileExtension.LOG,
      logsWriteDirectoryName: "SparkLogs",
      logsExportDirectoryName: "SparkLogs/Exported",
      debugFileOperations: true,
      isDebuggable: true);
}

class SparkApp extends StatelessWidget {
  const SparkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      translations: Messages(),
      locale: controller.currentLocale.value,
      fallbackLocale: const Locale('en', 'US'), // 添加一个回调语言选项，以备上面指定的语言翻译不存在
      theme: ThemeData.light(), // 主题切换 Get.changeTheme(ThemeData.light());
      debugShowCheckedModeBanner: false,
      initialBinding: MainBinding(), // 主页
      initialRoute: controller.isLoggedIn.value
          ? RouteConfig.main
          : RouteConfig.login, // 未登录跳转登录页，否则显示主页
      getPages: RouteConfig.getPages, // 配置路由
    );
  }
}
