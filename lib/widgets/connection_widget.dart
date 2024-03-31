import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparkmob/controller/main_controller.dart';

class ConnectionWidget extends StatelessWidget {
  final _controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _controller.mainState.connectionError.value
          ? Container(
              color: Colors.yellow, // 警告栏的背景颜色
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning, color: Colors.red), // 警告图标
                  const SizedBox(width: 8.0),
                  Text(
                    'toast.connection_error'.tr,
                    style: const TextStyle(color: Colors.red, fontSize: 16.0),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(), // 如果电量正常，返回一个空的SizedBox，不显示警告栏
    );
  }
}
