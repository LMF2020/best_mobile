import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparkmob/controller/main_controller.dart';
import 'package:sparkmob/subpages/join_meeting.dart';
import 'package:sparkmob/utils/app_const.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends GetView<MainController> {
  LoginPage({super.key});

  final _emailTextController = TextEditingController(text: "");
  final _passwordTextController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = controller.mainState;
    String? lastUserInput = controller.getData(APP.keyUserName);
    _emailTextController.text = lastUserInput;

    /// 组件加载完毕后，Obx才可以刷新子组件。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 隐私声明的变量
      state.disclaimer.value = controller.isDisclaimerChecked();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Form(
                key: _formKey,
                child: Center(
                  child: SizedBox(
                    height: Get.height,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/logo.png",
                            width: 200,
                            height: 200,
                          ),
                          Obx(() => TextFormField(
                                enabled: !state.loginProcess.value,
                                controller: _emailTextController,
                                decoration: InputDecoration(
                                    icon: const Icon(Icons.person),
                                    labelText: 'login.email'.tr),
                                validator: (String? value) =>
                                    EmailValidator.validate(value!)
                                        ? null
                                        : 'check.enter.valid.email'.tr,
                                onFieldSubmitted: (String? value) {
                                  // 记录登陆邮箱的历史
                                  controller.setData(
                                      APP.keyUserName, value ?? "");
                                },
                              )),
                          const SizedBox(height: 8),
                          Obx(() => TextFormField(
                                enabled: !state.loginProcess.value,
                                controller: _passwordTextController,
                                decoration: InputDecoration(
                                    icon: const Icon(Icons.lock),
                                    labelText: 'login.pwd'.tr,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        state.passwordVisible.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                      onPressed: () {
                                        state.passwordVisible.value =
                                            !state.passwordVisible.value;
                                      },
                                    )),
                                obscureText: !state.passwordVisible.value,
                                validator: (String? value) =>
                                    value!.trim().isEmpty
                                        ? 'check.enter.pwd.required'.tr
                                        : null,
                              )),
                          const SizedBox(height: 8),

                          /// 免责声明
                          if (APP.showPolicyTerms)
                            Row(
                              children: <Widget>[
                                Obx(() => Checkbox(
                                      value: state.disclaimer.value,
                                      onChanged: (value) {
                                        state.disclaimer.value = value ?? false;
                                        controller
                                            .checkDisclaimer(value ?? false);
                                      },
                                    )),
                                // 用户协议隐私声明的超链接
                                RichText(
                                  text: TextSpan(children: [
                                    const TextSpan(
                                      text: APP
                                          .disclaimerLoginPageAgreeTerm, // 我已同意
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: APP.disclaimerPolicyContent, // 用户协议
                                      style:
                                          const TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          final url = Uri.parse(APP
                                              .disclaimerPolicyContentUrl); // 用户协议URL
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          }
                                        },
                                    ),
                                    TextSpan(
                                      text:
                                          APP.disclaimerPrivacyContent, // 隐私政策
                                      style:
                                          const TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          final url = Uri.parse(
                                              APP.disclaimerPrivacyContentUrl);

                                          /// 隐私政策URL
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          }
                                        },
                                    )
                                  ]),
                                )
                              ], //<Widget>[]
                            ), //Row

                          const SizedBox(height: 30),
                          Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30),
                            color: state.loginProcess.value
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).primaryColor,
                            child: MaterialButton(
                              minWidth: Get.width,
                              padding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              onPressed: () async {
                                // 请先同意用户协议和隐私政策
                                if (!state.disclaimer.value &&
                                    APP.showPolicyTerms) {
                                  controller.showToast(
                                      'toast.login_must_agree_disclaimer', 3);
                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  // 登录
                                  controller.sdkLogin(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                    context: context,
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.person, color: Colors.white),
                                  const SizedBox(width: 5),
                                  Text(
                                    'login.btn'.tr,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // 直接加会---按钮
                          Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).primaryColorDark,
                            child: MaterialButton(
                              minWidth: Get.width,
                              padding:
                                  const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              onPressed: () {
                                // 点击进入加会页面
                                controller.onClickJoinMeeting(context: context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.video_camera_front,
                                      color: Colors.white),
                                  const SizedBox(width: 5),
                                  Text(
                                    'btn.join_meeting_without_login'.tr,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'client.version'.tr,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          )
                          // controller.isLoggedIn.value? Text('login.success'.tr): Text('login.fail'.tr),
                        ]),
                  ),
                ))),
      ),
    );
  }
}
