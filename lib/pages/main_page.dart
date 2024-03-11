import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparkmob/controller/main_controller.dart';
import 'package:sparkmob/model/destination.dart';

import '../subpages/meeting_list.dart';
import '../subpages/user_profile.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());

    final List<Widget> widgetList = [
      const MeetingPage(),
      const ProfilePage(),
    ];

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
          body: Obx(() => IndexedStack(
                index: controller.selectedIndex.value, // 绑定选中的索引
                children: widgetList,
              )),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: controller.selectedIndex.value, // 绑定选中的索引
              onTap: (index) {
                controller.setIndex(index);// 更新选中的索引
                // if(index == 0) {
                //   Navigator.popAndPushNamed(context,RouteConfig.main);
                // }
              },
              items:
                  MainController.allDestinations.map((Destination destination) {
                return BottomNavigationBarItem(
                  icon: Icon(destination.icon, color: destination.color),
                  label: destination.title.tr,
                );
              }).toList(),
            ),
          )),
    );
  }
}
