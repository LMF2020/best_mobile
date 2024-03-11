import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparkmob/controller/main_controller.dart';
import 'package:sparkmob/controller/main_state.dart';

class StartMeetingPage extends StatelessWidget {
  const StartMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController controller = Get.find();
    MainState state = controller.mainState;

    return Scaffold(
      appBar: AppBar(
        title: Text('title.start_meeting'.tr),
        centerTitle: true,
      ),
      body: CupertinoPageScaffold(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('switch.enable_video'.tr),
                  // This switch controls the existence of the green box
                  Obx(
                    () => CupertinoSwitch(
                      value: state.showEnableVideoBtn.value,
                      onChanged: (value) {
                        state.showEnableVideoBtn.value = value;
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
              const SizedBox(
                height: 30,
              ),
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
                          controller.startInstantMeetingWithoutLogin();
                        },
                        child: Text('btn.start_meeting'.tr),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
