import 'package:dio/dio.dart';
import 'app_const.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: "https://${APP.domain}",
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ),
);