import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonUI {
  /// IOS风格的确认框
  static showCupertinoAlertDialog({
    required title,
    required content,
    required okBtn,
    String subContent = "", // 附加文本
  }) {
    bool displaySubContent = subContent.isNotEmpty;
    showCupertinoDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                content,
                style: const TextStyle(fontSize: 16), // 上面文本的字体大小
              ),
              if (displaySubContent) const SizedBox(height: 8), // 添加一些间距
              if (displaySubContent)
                Text(
                  subContent,
                  style: const TextStyle(fontSize: 14), // 下面文本的字体大小
                ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(okBtn),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// 弹出确认框
  static showConfirmationAlertDialog(
    BuildContext context, {
    required String title,
    required String middleText,
    required String cancelText,
    required String confirmText,
    required Function onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(middleText),
          actions: <Widget>[
            MaterialButton(
              color: Colors.teal,
              child: Text(
                cancelText,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              color: Colors.red,
              child: Text(
                confirmText,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                onConfirm();
              },
            )
          ],
        );
      },
    );
  }

  static void showBanner(
      BuildContext context, String message, Function? onClick) {
    ScaffoldMessenger.of(context)
      ..removeCurrentMaterialBanner()
      ..showMaterialBanner(_showMaterialBanner(context, message, onClick));
  }

  static void hideBanner(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }

  static MaterialBanner _showMaterialBanner(
      BuildContext context, String message, Function? onClick) {
    return MaterialBanner(
        content: Text(message),
        leading: const Icon(Icons.error),
        padding: const EdgeInsets.all(15),
        backgroundColor: const Color(0xE7D7D7FF),
        contentTextStyle: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.bold, color: Colors.indigo),
        actions: [
          // TextButton(
          //   onPressed: () {},
          //   child: Text(
          //     'Agree',
          //     style: TextStyle(color: Colors.purple),
          //   ),
          // ),
          TextButton(
            onPressed: () {
              onClick?.call();
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: Text(
              'message.gotcha'.tr,
              style: const TextStyle(
                  color: Colors.purple,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]);
  }
}
