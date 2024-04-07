import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparkmob/controller/main_controller.dart';
import 'package:sparkmob/controller/main_state.dart';
import 'package:sparkmob/model/editOptions.dart';
import 'package:sparkmob/widgets/connection_widget.dart';
import 'package:sparkmob/widgets/timezone_picker.dart';

import '../config/route_config.dart';
import '../model/meeting.dart';
import '../utils/common_utils.dart';
import '../widgets/common_ui.dart';

class EditMeetingPage extends StatelessWidget {
  final TextEditingController meetingTopicController = TextEditingController();
  final TextEditingController meetingPwdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final Meeting meeting;

  EditMeetingPage(this.meeting, {super.key});

  @override
  Widget build(BuildContext context) {
    MainController controller = Get.find();
    MainState state = controller.mainState;

    var meetingTopic = meeting.topic ?? "";
    var displayName = state.loginUser.value.displayName ?? "";
    var email = state.loginUser.value.email ?? "";
    if (meetingTopic.isNotEmpty) {
      meetingTopicController.text = meetingTopic;
    } else if (displayName.isNotEmpty) {
      meetingTopicController.text =
          displayName + "schedule.default_meeting_topic".tr;
    } else if (email.isNotEmpty) {
      meetingTopicController.text = email + "schedule.default_meeting_topic".tr;
    } else {
      meetingTopicController.text = 'my.schedule_meeting_topic'.tr;
    }

    meetingTopicController.text = meeting.topic ??
        state.loginUser.value.displayName ??
        "schedule.default_meeting_topic".tr;
    meetingPwdController.text = meeting.password ?? "";

    return Scaffold(
      appBar: AppBar(
        title: Text('meeting.edit'.tr),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              Get.back();
            }),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              // 提交
              if (_formKey.currentState!.validate()) {
                String topic = meetingTopicController.text;
                String startTime = Utils.formatDateTimeToString(
                    controller.choseScheduleDateTime.value);
                int duration =
                    Utils.getDuration(controller.choseScheduleDuration.value);
                String password = meetingPwdController.text;
                bool optionHostVideo = state.hostEnableVideo.value;
                bool optionParticipantsVideo =
                    state.participantEnableVideo.value;
                bool optionJbh = state.enableJBH.value;
                bool optionWaitingRoom = state.enableWaitingRoom.value;
                bool optionUsePmi = state.showEnablePMIBtn.value;

                EditOptions editOpt = EditOptions(
                  meeting.uuid,
                  meeting.meetingNumb,
                  meeting.hostId,
                  topic,
                  startTime,
                  duration: duration,
                  password: password,
                  optionUsePmi: optionUsePmi,
                  optionHostVideo: optionHostVideo,
                  optionParticipantsVideo: optionParticipantsVideo,
                  optionJbh: optionJbh,
                  optionWaitingRoom: optionWaitingRoom,
                );

                // print('---- editOpt -----\n$editOpt');

                onSuccess() {
                  // 会议编辑成功 -- 刷新会议列表
                  controller.listHostMeetings();
                  Get.snackbar(
                    "snack-bar.message_warning".tr,
                    "toast.edit_meeting.submit.success".tr,
                    colorText: Colors.white,
                    backgroundColor: Colors.brown,
                    duration: const Duration(seconds: 5),
                  );
                  Get.toNamed(RouteConfig.main);
                }

                onFail(error) {
                  // Get.snackbar(
                  //   "snack-bar.message_warning".tr,
                  //   "toast.edit_meeting.submit.fail".tr,
                  //   colorText: Colors.white,
                  //   backgroundColor: Colors.brown,
                  //   duration: const Duration(seconds: 5),
                  // );
                  /// 编辑会议失败提示框
                  controller.failAlert(
                      'toast.edit_meeting.submit.fail', error.toString());
                }

                CommonUI.showConfirmationAlertDialog(
                  context,
                  title: 'title.edit_meeting.submit'.tr,
                  middleText: 'confirm.schedule_meeting.submit'.tr,
                  cancelText: 'btn.cancel'.tr,
                  confirmText: 'btn.confirm'.tr,
                  onConfirm: () {
                    // api编辑
                    controller.editMeeting(editOpt, onSuccess, onFail);
                  },
                );
              }
            },
          )
        ],
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
                  const SizedBox(height: 12.0),
                  SizedBox(
                      height: 90.0,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          // labelText: '会议主题',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: TextFormField(
                          // 输入会议主题
                          controller: meetingTopicController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'hint.schedule.meeting_topic'.tr,
                            hintStyle: const TextStyle(fontSize: 12.0),
                          ),
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return 'hint.schedule.meeting_topic'.tr;
                            }
                            return null;
                          },
                        ),
                      )),

                  const SizedBox(height: 12.0),
                  // SizedBox(
                  //   height: 35.0,
                  //   child: Container(
                  //     decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
                  //   ),
                  // ),
                  // const SizedBox(height: 12.0),
                  // const SizedBox(height: 16.0),

                  /// 预约会议开始时间
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'meeting.schedule.start_date'.tr,
                      ),
                      GestureDetector(
                        onTap: () {
                          // 选择时间
                          String locale =
                              controller.currentLocale.value.languageCode;
                          controller.showChoseScheduleDatePicker(
                              context, locale);
                        },
                        child: Obx(
                          () => Text(
                              "${Utils.formatDateTimeLocal(controller.choseScheduleDateTime.value, controller.currentLocale.value.languageCode)} >",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w300)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  /// 会议时长
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'meeting.schedule.duration'.tr,
                      ),
                      GestureDetector(
                        onTap: () {
                          // 选择时间
                          String locale =
                              controller.currentLocale.value.languageCode;
                          controller.showChoseTimePicker(context, locale);
                        },
                        child: Obx(
                          () => Text(
                              "${Utils.formatTimeLocal(controller.choseScheduleDuration.value, controller.currentLocale.value.languageCode)} >",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w300)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  /// 选择时区
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'meeting.schedule.timezone'.tr,
                      ),
                      const TimezoneDropdown(),
                    ],
                  ),

                  const SizedBox(
                    height: 12.0,
                  ),
                  SizedBox(
                    height: 35.0,
                    child: Container(
                      decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  /// 需要密码
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'opt.schedule.requirePwd'.tr,
                      ),
                      Obx(
                        () => CupertinoSwitch(
                          activeColor: CupertinoColors.activeBlue,
                          trackColor: CupertinoColors.inactiveGray,
                          thumbColor: CupertinoColors.white,
                          value: state.needScheduleMeetingPwd.value,
                          onChanged: (bool value) {
                            state.needScheduleMeetingPwd.value = value;
                            if (!value) {
                              meetingPwdController.text = "";
                            }
                          },
                        ),
                      )
                    ],
                  ),

                  /// 输入密码框
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text('meeting.schedule.pwd'.tr),
                      Expanded(
                          child: Obx(
                        () => TextFormField(
                          controller: meetingPwdController,
                          keyboardType: TextInputType.text,
                          enabled: state.needScheduleMeetingPwd.value,
                          decoration: InputDecoration(
                            hintText: 'meeting.pwd.required'.tr,
                            hintStyle: const TextStyle(fontSize: 12.0),
                          ),
                          validator: (value) {
                            // 验证密码
                            if (state.needScheduleMeetingPwd.value &&
                                value!.trim().isEmpty) {
                              return 'meeting.pwd.required'.tr;
                            }
                            if (state.needScheduleMeetingPwd.value &&
                                !Utils.isNumeric(value!)) {
                              return 'meeting.pwd.invalid'.tr;
                            }
                            return null;
                          },
                        ),
                      )),
                    ],
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  /// 使用个人会议号
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('switch.use_pmi'.tr),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(
                            () => Text(
                              /// 显示个人会议号(PMI)
                              state.loginUser.value.pmi.toString(),
                              style: const TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      // this switch controls the existence of the blue box
                      Obx(
                        () => CupertinoSwitch(
                          activeColor: CupertinoColors.activeBlue,
                          trackColor: CupertinoColors.inactiveGray,
                          thumbColor: CupertinoColors.white,
                          value: state.showEnablePMIBtn.value,
                          onChanged: (value) {
                            state.showEnablePMIBtn.value = value;
                          },
                        ),
                      )
                    ],
                  ),

                  /// 主持人视频开启
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'opt.schedule.host_enable_video'.tr,
                      ),
                      Obx(
                        () => CupertinoSwitch(
                          activeColor: CupertinoColors.activeBlue,
                          trackColor: CupertinoColors.inactiveGray,
                          thumbColor: CupertinoColors.white,
                          value: state.hostEnableVideo.value,
                          onChanged: (bool value) {
                            state.hostEnableVideo.value = value;
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  /// 参会者视频开启
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'opt.schedule.participant_enable_video'.tr,
                      ),
                      Obx(
                        () => CupertinoSwitch(
                          activeColor: CupertinoColors.activeBlue,
                          trackColor: CupertinoColors.inactiveGray,
                          thumbColor: CupertinoColors.white,
                          value: state.participantEnableVideo.value,
                          onChanged: (bool value) {
                            state.participantEnableVideo.value = value;
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  /// 允许参会者随时加会
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'opt.schedule.jbh_enable'.tr,
                      ),
                      Obx(
                        () => CupertinoSwitch(
                          activeColor: CupertinoColors.activeBlue,
                          trackColor: CupertinoColors.inactiveGray,
                          thumbColor: CupertinoColors.white,
                          value: state.enableJBH.value,
                          onChanged: (bool value) {
                            state.enableJBH.value = value;
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  /// 启用等候室
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'opt.schedule.waiting_room_enable'.tr,
                      ),
                      Obx(
                        () => CupertinoSwitch(
                          activeColor: CupertinoColors.activeBlue,
                          trackColor: CupertinoColors.inactiveGray,
                          thumbColor: CupertinoColors.white,
                          value: state.enableWaitingRoom.value,
                          onChanged: (bool value) {
                            state.enableWaitingRoom.value = value;
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
