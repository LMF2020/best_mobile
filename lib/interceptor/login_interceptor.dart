import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparkmob/controller/main_controller.dart';

import '../config/route_config.dart';

class LoginMiddleware extends GetMiddleware {
  final MainController controller = Get.find<MainController>();

  @override
  RouteSettings? redirect(String? route) {
    // 检查令牌是否存在
    bool tokenExists = controller.isTokenExist();

    if (!tokenExists) {
      // 令牌不存在，跳转到登录页
      print('用户未登录');
      return const RouteSettings(name: RouteConfig.login);
    }
    print('用户已登录');
    return null; // 没有重定向
  }
}
