import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparkmob/controller/main_state.dart';

import '../config/route_config.dart';
import '../controller/main_controller.dart';
import '../widgets/common_ui.dart';
import '../widgets/http_image.dart';

/// 账户信息页面
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MainController controller = Get.find();
    MainState state = controller.mainState;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('title.profile'.tr),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 邮箱
                    Text(
                      'profile.email'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(state.loginUser.value.email ?? ""),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 显示名称
                    Text(
                      'profile.display_name'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                        "${state.loginUser.value.firstName ?? ""} ${state.loginUser.value.lastName ?? ""}"),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 显示头像
                    Text(
                      'profile.avatar'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    HttpImage(
                      imageUrl: state.loginUser.value.picUrl ?? "",
                      defaultImg: 'assets/default_avatar.png',
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 显示头像
                    Text(
                      'language.settings'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    DropdownButton<Locale>(
                      value: controller.currentLocale.value,
                      items: controller.supportedLocales.map((Locale locale) {
                        return DropdownMenuItem<Locale>(
                          value: locale,
                          child: Text(locale.languageCode == 'zh'? 'language.zh'.tr: 'language.en'.tr),
                        );
                      }).toList(),
                      onChanged: (Locale? locale) {
                        controller.changeLocale(locale!);
                        // 路由重置以刷新语言
                        Navigator.popAndPushNamed(context, RouteConfig.main);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () {
                            CommonUI.showConfirmationAlertDialog(
                              context,
                              title: 'btn.exit_app'.tr,
                              middleText: 'profile.prompt_exit_app'.tr,
                              cancelText: 'btn.cancel'.tr,
                              confirmText: 'btn.confirm'.tr,
                              onConfirm: () {
                                /// 退出登录成功
                                onSuccess() {
                                  print('--- Loginout success ---');
                                  Get.toNamed(RouteConfig.login);
                                }
                                /// 退出登录
                                controller.sdkLogout(onSuccess);
                              },
                            );
                          },
                          child: Text('btn.exit_app'.tr),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
