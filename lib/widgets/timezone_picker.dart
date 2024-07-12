import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/main_controller.dart';
import '../controller/main_state.dart';

class TimezoneDropdown extends StatelessWidget {
  const TimezoneDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    MainController controller = Get.find();
    MainState state = controller.mainState;
    return Obx(() {
      return DropdownButton<String>(
        value: state.timeZoneSelected.value,
        onChanged: (value) {
          state.timeZoneSelected.value = value!;
        },
        items: <String>['UTC', 'Asia/Shanghai']
            .map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(
              value,
            ),
          );
        }).toList(),
      );
    });
  }
}
