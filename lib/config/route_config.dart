import 'package:get/get.dart';
import 'package:sparkmob/controller/main_binding.dart';

import '../pages/login_page.dart';
import '../pages/main_page.dart';
import '../subpages/start_meeting.dart';

class RouteConfig {
  static const String main = "/main";
  static const String login = "/login";
  static const String startMeeting = "/start_meeting";

  static final List<GetPage> getPages = [
    GetPage(
      name: login,
      page: () => LoginPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: main,
      page: () => const MainPage(),
      // middlewares: [LoginMiddleware()],
      binding: MainBinding(),
    ),
    GetPage(
      name: startMeeting,
      page: () => const StartMeetingPage(),
      binding: MainBinding(), // 新会议
    ),
  ];
}
