import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparkmob/config/route_config.dart';
import 'package:sparkmob/controller/main_controller.dart';
import 'package:sparkmob/controller/main_state.dart';
import 'package:sparkmob/utils/app_const.dart';
import 'package:sparkmob/widgets/connection_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/common_utils.dart';

class JoinMeetingPage extends StatelessWidget {
  final TextEditingController meetingNumberController = TextEditingController();
  final TextEditingController meetingTopicController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  JoinMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController controller = Get.find();
    MainState state = controller.mainState;

    /// 从本地读取缓存的加会用户名，不存在则尝试获取登录用户名，未登录则为空
    var displayName = controller.getData(APP.keyJoinDisplayName);
    if (Utils.validateInput(displayName)) {
      meetingTopicController.text = displayName;
    } else {
      meetingTopicController.text = state.loginUser.value.displayName ?? "";
    }

    String? selectedMeeting;

    // 历史会议列表
    // final List<Map<String, dynamic>> historyMeetings = [
    //   {'title': 'Meeting 11111111111111111111111111111111', 'number': '123456'},
    //   {'title': 'Meeting 2进口机动车看见到处能看到才能看多久才能打开', 'number': '789012'},
    //   {'title': 'Meeting 3', 'number': '345678'},
    //   {'title': 'Meeting 3', 'number': '345678'},
    //   {'title': 'Meeting 3', 'number': '345678'},
    //   {'title': 'Meeting 3', 'number': '345678'},
    //   {'title': 'Meeting 3', 'number': '345678'},
    //   {'title': 'Meeting 3', 'number': '345678'},
    //   {'title': 'Meeting 3', 'number': '345678'},
    //   {'title': 'Meeting 3', 'number': '345678'},
    //   {'title': 'Meeting 3', 'number': '345678'},
    //   {'title': 'Meeting 3', 'number': '345678'},
    //   {'title': 'Meeting 3', 'number': '345678'},
    //   {'title': 'Meeting 3', 'number': '345678'},
    //   {'title': 'Meeting 3', 'number': '345678'},
    // ];

    // 清除历史记录
    void clearHistory() {
      state.meetingHistoryList.clear();
      controller.setMeetingHistory([]);
      Navigator.pop(context); // 关闭底部弹出框
    }

    // 底部弹出选择框
    void showMeetingOptions() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              ElevatedButton(
                onPressed: clearHistory,
                child: Text('meeting.clear_history'.tr),
              ),
              Expanded(
                child: ListView(
                  children: state.meetingHistoryList.map((meeting) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: Row(
                        children: [
                          Expanded(child: Text(meeting['title'])),
                          const SizedBox(width: 8),
                          Text('${meeting['number']}'),
                        ],
                      ),
                      onTap: () {
                        selectedMeeting = meeting['number'];
                        meetingNumberController.text = selectedMeeting!;
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('meeting.join'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConnectionWidget(), // 网络连接检测
                  Text(
                    'text.meeting_numb'.tr,
                    // style: TextStyle(fontSize: 18.0),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            TextFormField(
                              // 输入会议号
                              controller: meetingNumberController,
                              keyboardType: TextInputType.number,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'hint.meeting_numb'.tr,
                                hintStyle: const TextStyle(fontSize: 12.0),
                              ),
                              validator: (String? value) {
                                if (value!.trim().isEmpty) {
                                  return 'check.meeting_numb.not_empty'.tr;
                                }
                                if (!Utils.isNumeric(value) ||
                                    value.length < 5) {
                                  return 'check.meeting_numb.format_error'.tr;
                                }
                                return null;
                              },
                            ),
                            // 下拉按钮 - 弹出历史会议记录
                            Positioned(
                              right: 0,
                              bottom: 0,
                              top: 0,
                              child: IconButton(
                                onPressed: showMeetingOptions,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  size: 36,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),
                  Text(
                    'join.participant_name'.tr,
                    // style: TextStyle(fontSize: 18.0),
                  ),
                  TextFormField(
                    // 输入参会者名称
                    controller: meetingTopicController,
                    decoration: InputDecoration(
                      hintText: 'hint.participant_name'.tr,
                      hintStyle: const TextStyle(fontSize: 12.0),
                    ),
                    validator: (String? value) {
                      if (value!.trim().isEmpty) {
                        return 'check.participant_name.not_empty'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize:
                              WidgetStateProperty.all(const Size(120, 40)),
                          backgroundColor: WidgetStateProperty.all(Colors.blue),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                          textStyle: WidgetStateProperty.all(
                              const TextStyle(fontSize: 12)),
                          // 设置文字样式
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))), // 设置形状
                        ),
                        onPressed: state.isButtonDisabled.isTrue
                            ? null
                            : () {
                                // 隐藏数字键盘
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  String meetingNumb =
                                      meetingNumberController.text;
                                  String displayName =
                                      meetingTopicController.text;
                                  // 写入本地缓存，以便下次仍旧可以获取到displayName
                                  controller.setData(
                                      APP.keyJoinDisplayName, displayName);
                                  // join meeting
                                  print("--- joining meeting ---$displayName");

                                  // 调用API 通过会议号获取会议成功
                                  onSuccess(meeting) {
                                    print('ret meeting numb: ' +
                                        meeting.meetingNumb);
                                    print('ret meeting pass: ' +
                                        meeting?.password);

                                    if (meeting.password == '' ||
                                        meeting.password == null) {
                                      /// 设置按钮不可点击
                                      controller.setSubmitButtonDisable();

                                      /// 设置按钮3秒后可点击
                                      controller.setSubmitButtonAvailable();
                                      // 不带密码，直接加会
                                      controller.joinMeeting("",
                                          topic: meeting.topic,
                                          displayName: displayName,
                                          meetingNumb: meetingNumb);
                                      return;
                                    }
                                    // 带密码，弹框提示输入密码
                                    controller.showJoinPasswordDialog(
                                      displayName,
                                      meeting.meetingNumb,
                                      meeting.password,
                                      meeting.topic,
                                    );
                                  }

                                  // 调用API 通过会议号获取会议失败
                                  onFail(error) {
                                    // print("ret error code: " + errorMap['code']);
                                    // print("ret error message: " +
                                    //     errorMap['message']);
                                    // Get.snackbar(
                                    //   "snack-bar.message_warning".tr,
                                    //   errorMap['message'],
                                    //   colorText: Colors.white,
                                    //   backgroundColor: Colors.brown,
                                    //   duration: const Duration(seconds: 5),
                                    // );
                                    /// 获取会议失败提示框
                                    controller.failAlert(
                                        'toast.get_meeting.failed',
                                        error.toString());
                                  }

                                  /// API 根据会议号获取会议
                                  /// 如果会议不存在 -> 弹框会议不存在或过期
                                  /// 如果会议存在 -> 返回会议密码
                                  controller.getMeetingByNumb(
                                      meetingNumb, onSuccess, onFail);
                                }
                              },
                        child: Text('btn.join_meeting'.tr),
                      ),
                      const SizedBox(width: 20), // 添加一些间距
                      if (controller.isLoggedIn.isFalse &&
                          !controller.isTokenExist()) // token不存在或者未登陆，则显示登陆按钮
                        ElevatedButton(
                          style: ButtonStyle(
                            minimumSize:
                                WidgetStateProperty.all(const Size(120, 40)),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white70),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.purple),
                            textStyle: WidgetStateProperty.all(
                                const TextStyle(fontSize: 12)),
                            // 设置文字样式
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12))), // 设置形状
                          ),
                          onPressed: () {
                            // 返回登陆页面
                            Get.toNamed(RouteConfig.login);
                          },
                          child: Text('login.back_to_login'.tr),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'opt.auto_connect_audio'.tr,
                      ),
                      Obx(
                        () => CupertinoSwitch(
                          activeColor: CupertinoColors.activeBlue,
                          trackColor: CupertinoColors.inactiveGray,
                          thumbColor: CupertinoColors.white,
                          value: state.autoConnectAudio.value,
                          onChanged: (bool value) {
                            state.autoConnectAudio.value = value;
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'opt.keep_camera_off'.tr,
                      ),
                      Obx(
                        () => CupertinoSwitch(
                          activeColor: CupertinoColors.activeBlue,
                          trackColor: CupertinoColors.inactiveGray,
                          thumbColor: CupertinoColors.white,
                          value: state.keepCameraOff.value,
                          onChanged: (bool value) {
                            state.keepCameraOff.value = value;
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  /// 同意用户协议和隐私政策
                  if (APP.showPolicyTerms)
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'disclaimerJoinPageAgreeTerm'.tr, // 我同意
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'disclaimerPolicyContent'.tr, // 用户协议
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url = Uri.parse(
                                  APP.disclaimerPolicyContentUrl); // 用户协议URL
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                        ),
                        TextSpan(
                          text: 'disclaimerPolicyContentUrl'.tr, // 隐私政策
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final url =
                                  Uri.parse(APP.disclaimerPrivacyContentUrl);

                              /// 隐私政策URL
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                        )
                      ]),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
