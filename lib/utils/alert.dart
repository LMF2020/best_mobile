/*
百佳会反诈提醒：谨防视频会议诈骗，跟钱财有关要求进会共享的都是骗子！牢记银行卡余额不共享，人脸识别不要做！共享屏幕不要做！遇到威胁别害怕，一旦难分真或假，立即拨打96110！！！
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';

const fraudMsg =
    "百佳会反诈提醒：谨防视频会议诈骗，跟钱财有关要求进会共享的都是骗子！牢记银行卡余额不共享，人脸识别不要做！共享屏幕不要做！遇到威胁别害怕，一旦难分真或假，立即拨打96110！！！";

class AlertUtil {
  static void showFraudAlert({int durationInSeconds = 15}) {
    if (Get.isSnackbarOpen) {
      return; // 如果 Snackbar 已经打开，不再弹出新的
    }
    Get.snackbar(
      '警告',
      fraudMsg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      duration: Duration(seconds: durationInSeconds),
      mainButton: TextButton(
        onPressed: () {
          Get.closeAllSnackbars();
        },
        child: const Text(
          '关闭',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
