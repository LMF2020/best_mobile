import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparkmob/utils/common_utils.dart';
import 'package:sparkmob/widgets/connection_widget.dart';

import '../config/route_config.dart';
import '../controller/main_controller.dart';
import '../model/meeting.dart';
import '../widgets/common_ui.dart';
import 'edit_meeting.dart';

/// 会议详情页面
class MeetingDetailPage extends StatelessWidget {
  final Meeting meeting;

  const MeetingDetailPage({
    super.key,
    required this.meeting,
  });

  @override
  Widget build(BuildContext context) {
    MainController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('meeting.detail'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConnectionWidget(), // 网络连接检测
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'text.meeting_topic'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                // SizedBox(height: 8.0),
                Text(meeting.topic ?? ""),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'meeting.number'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Text(meeting.meetingNumb),
              ],
            ),
            const SizedBox(height: 16.0),
            if (meeting.startTimeUTC != '')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'meeting.start_time'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(Utils.formatDateTimeLocal(
                      meeting.startTimeDate ?? DateTime.now(),
                      controller.currentLocale.value.languageCode))
                ],
              ),
            if (meeting.startTimeUTC != '') const SizedBox(height: 16.0),
            if (meeting.password != null && meeting.password != '')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'meeting.pwd'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(meeting.password.toString()),
                ],
              ),
            if (meeting.password != null && meeting.password != '')
              const SizedBox(height: 16.0),

            /// 开始会议
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          backgroundColor: Colors.white, // 设置按钮的背景色为白色
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // 设置圆角的大小
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                      onPressed: () {
                        controller.startWithMeetingNumb(
                            meetingTopic:
                                meeting.topic ?? "This meeting has no topic",
                            meetingNumb: meeting.meetingNumb);
                      },
                      child: Text('btn.start_meeting'.tr),
                    ),
                  ),
                ),
              ],
            ),
            if (meeting.type == 2) const SizedBox(height: 16.0),

            /// 编辑会议 /// 只有预约会议才能编辑，周期性会议暂时不支持编辑
            if (meeting.type == 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            backgroundColor: Colors.white, // 设置按钮的背景色为白色
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // 设置圆角的大小
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            )),
                        onPressed: () {
                          /// 给编辑会议的参数赋值
                          controller.pageInitForEditMeeting(meeting);

                          /// 跳转到编辑会议页面
                          Get.to(
                            () => EditMeetingPage(meeting),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Text('btn.edit_meeting'.tr),
                      ),
                    ),
                  ),
                ],
              ),

            /// 删除会议
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
                          backgroundColor: Colors.white, // 设置按钮的背景色为白色
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // 设置圆角的大小
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold, // 设置字体加粗
                          )),
                      onPressed: () {
                        CommonUI.showConfirmationAlertDialog(
                          context,
                          title: 'meeting.del'.tr,
                          middleText: 'meeting.del_prompt'.tr,
                          cancelText: 'btn.cancel'.tr,
                          confirmText: 'btn.confirm'.tr,
                          onConfirm: () {
                            Get.back();
                            Get.toNamed(RouteConfig.main);
                            // 删除会议
                            controller.deleteMeetingById(meeting.uuid, () {
                              // 删除成功 - 刷新会议列表
                              controller.listHostMeetings();
                            }, (error) {
                              controller.failAlert(
                                  'toast.delete_meeting.failed',
                                  error.toString());
                            });
                          },
                        );
                      },
                      child: Text('btn.del_meeting'.tr),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
