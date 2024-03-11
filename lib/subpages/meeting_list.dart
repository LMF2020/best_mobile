import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparkmob/controller/main_controller.dart';
import 'package:sparkmob/subpages/join_meeting.dart';
import 'package:sparkmob/subpages/meeting_detail.dart';
import 'package:sparkmob/subpages/schedule_meeting.dart';
import 'package:sparkmob/subpages/start_meeting.dart';

class MeetingPage extends StatelessWidget {
  const MeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('title.meeting'.tr),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // 导航栏最左边按钮点击事件
            // 在此处编写对应的代码
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // 刷新会议列表
            onPressed: () {
              // 刷新会议列表
              controller.listHostMeetings();
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20.0), // 设置顶部间距为16
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 开会
                        Get.to(
                          () => const StartMeetingPage(),
                          transition: Transition.downToUp,
                        );
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size.fromRadius(40.0)), // 设置按钮的最小尺寸（半径为40.0）
                      ),
                      child: const SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: Icon(
                          Icons.video_call,
                          size: 40.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'btn.new_meeting'.tr,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 点击加会
                        Get.to(
                          () => JoinMeetingPage(key: UniqueKey()),
                          transition: Transition.downToUp,
                        );
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size.fromRadius(40.0)),
                      ),
                      child: const SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: Icon(
                          Icons.add,
                          size: 40.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'btn.join_meeting'.tr,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 初始化默认参数
                        controller.pageInitForScheduleMeeting();

                        /// 跳转到预约会议页面
                        Get.to(
                          () => ScheduleMeetingPage(),
                          transition: Transition.downToUp,
                        );
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size.fromRadius(40.0)),
                      ),
                      child: const SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: Icon(
                          Icons.calendar_month,
                          size: 40.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'btn.schedule_meeting'.tr,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(child: Obx(() {
              if (controller.isLoading.value) {
                // 请求中加载等待框
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (controller.meetings.isEmpty) {
                // meeting列表数据为空
                return Center(
                  child: Text('list.no_schedule_meeting'.tr),
                );
              } else {
                return ListView.builder(
                    itemCount: controller.meetings.length,
                    itemBuilder: (context, index) {
                      // 遍历请求返回的meeting数据
                      var meeting = controller.meetings[index];

                      Text dateYmdText;
                      Widget dateHmsText;
                      // 周期会议
                      bool isRecurringMeeting = meeting.startTimeYMD == "";
                      if (isRecurringMeeting) {
                        dateYmdText = Text("meeting.type_recurring".tr,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ));
                        dateHmsText = const SizedBox(); // 不占空间
                      } else {
                        // 列表显示日期
                        dateYmdText = Text(meeting.startTimeYMD!,
                            style: const TextStyle(fontSize: 16));
                        dateHmsText = Text(meeting.startTimeHMS!,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey));
                      }
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.all(5),
                        child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            /// 显示年月日-时分秒
                            children: [dateYmdText, dateHmsText],
                          ),
                          title: Align(
                            alignment: Alignment.center,
                            child: Text(meeting.topic ?? ""),
                          ),
                          subtitle: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                'text.meeting_numb'.tr + meeting.meetingNumb),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Get.to(
                              () => MeetingDetailPage(meeting: meeting),
                              transition: Transition.rightToLeftWithFade,
                            );
                            // Navigator.pushNamed(context, '/detail');
                          },
                        ),
                      );
                    });
              }
            })),
          ],
        ),
      ),
    );
  }
}
