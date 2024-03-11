import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonUI {
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
        return AlertDialog(
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

  static void showBanner(BuildContext context, String message, Function? onClick) {
    ScaffoldMessenger.of(context)
      ..removeCurrentMaterialBanner()
      ..showMaterialBanner(_showMaterialBanner(context, message, onClick));
  }

  static void hideBanner(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }

  static MaterialBanner _showMaterialBanner(BuildContext context, String message, Function? onClick) {
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
              style: const TextStyle(color: Colors.purple, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ]);
  }
}
