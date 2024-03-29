import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/user.dart';

class MainState {
  var loginProcess = false.obs;
  var passwordVisible = false.obs;
  var email = ''.obs; // 用户邮箱
  var accessToken = ''.obs; // 用户login token
  var zak = ''.obs; // 用户zak

  // 开启视频
  final RxBool showEnableVideoBtn = false.obs;

  // 使用PMI开会
  final RxBool showEnablePMIBtn = false.obs;

  // 自动连接语音
  final RxBool autoConnectAudio = false.obs;

  // 保持摄像头关闭
  final RxBool keepCameraOff = true.obs;

  ////////// 安排会议的选项 ///////
  final RxBool hostEnableVideo = true.obs;
  final RxBool participantEnableVideo = false.obs;
  final RxBool enableJBH = false.obs;
  final RxBool enableWaitingRoom = false.obs;
  final RxBool needScheduleMeetingPwd = true.obs;
  final RxString timeZoneSelected = 'Asia/Shanghai'.obs;
  final RxBool disclaimer = false.obs;

  /// get local storge
  final storge = GetStorage();

  /// 防止用户重复点击按钮
  final RxBool isButtonDisabled = false.obs;

  // 登录用户
  Rx<User> loginUser = User().obs;

  // 内存里保存会议历史记录
  var meetingHistoryList = [];

  MainState();
}
