import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sparkmob/controller/main_state.dart';
import 'package:sparkmob/model/destination.dart';
import 'package:sparkmob/model/scheduleOptions.dart';
import 'package:sparkmob/utils/common_utils.dart';
import 'package:sparkmob/utils/db_user.dart';
import 'package:sparkmob/widgets/common_ui.dart';

import '../api/http_api.dart';
import '../config/route_config.dart';
import '../model/editOptions.dart';
import '../model/meeting.dart';
import '../sdk/zoom_options.dart';
import '../sdk/zoom_view.dart';
import '../utils/app_const.dart';

class MainController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final HttpsAPI _api = Get.put(HttpsAPI());

  static const List<Destination> allDestinations = <Destination>[
    Destination(0, 'nav.meeting', Icons.videocam_outlined, Colors.teal),
    Destination(1, 'nav.profile', Icons.person_outline_rounded, Colors.cyan),
  ];
  MainState mainState = MainState();

  var selectedIndex = 0.obs; // 响应式状态
  var isLoading = true.obs; // 显示加载
  var meetings = <Meeting>[].obs; // 会议列表
  var isLoggedIn = false.obs; // 跳转到主页
  var choseScheduleDateTime = DateTime.now().obs; // 预约会议开始时间
  var choseScheduleDuration = DateTime(0, 0, 0, 1).obs; // 预约会议时长

  final joinMeetingPasswordCtrl = TextEditingController();
  final joinMeetingPasswordTitle = ('meeting.pwd.required'.tr).obs;

  late Timer timer;

  // 多语言选项配置
  var currentLocale = const Locale('zh', 'CN').obs;
  List<Locale> supportedLocales = [
    const Locale('zh', 'CN'),
    const Locale('en', 'US'),
    // const Locale.fromSubtags(
    //     languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
  ];

  void setIndex(int index) {
    selectedIndex.value = index; // 更新索引值
  }

  @override
  void onInit() {
    // 初始化应用
    sdkInit();
    super.onInit();
  }

  @override
  void onClose() {
    DBUtil.db.close();
    super.onClose();
  }

  /// 免责声明
  void checkDisclaimer(bool val) {
    mainState.storge.write("disclaimer", val);
  }

  bool isDisclaimerChecked() {
    return mainState.storge.read("disclaimer") ?? false;
  }

  /// 将按钮设置为不可点击
  void setSubmitButtonDisable() {
    mainState.isButtonDisabled.value = true;
  }

  /// 将按钮设置为可用
  void setSubmitButtonAvailable() {
    Future.delayed(const Duration(seconds: 3), () {
      mainState.isButtonDisabled.value = false;
    });
  }

  /// 预约会议时调用，初始化会议参数
  void pageInitForScheduleMeeting() {
    choseScheduleDateTime.value = DateTime.now();
    choseScheduleDuration.value = DateTime(0, 0, 0, 1);
    mainState.timeZoneSelected.value = 'Asia/Shanghai';
    mainState.needScheduleMeetingPwd.value = false;
    mainState.showEnablePMIBtn.value = false;
    mainState.hostEnableVideo.value = true;
    mainState.participantEnableVideo.value = false;
    mainState.enableJBH.value = false;
    mainState.enableWaitingRoom.value = false;
  }

  /// 编辑会议时调用
  void pageInitForEditMeeting(Meeting meeting) {
    choseScheduleDateTime.value = meeting.startTimeDate ?? DateTime.now();
    choseScheduleDuration.value =
        Utils.formatMinutesToDuration(meeting.duration ?? 60);
    mainState.timeZoneSelected.value = meeting.timezone;
    if (meeting.password == null || meeting.password == "") {
      mainState.needScheduleMeetingPwd.value = false;
    } else {
      mainState.needScheduleMeetingPwd.value = true;
    }
    mainState.showEnablePMIBtn.value = meeting.optionUsePmi;
    mainState.hostEnableVideo.value = meeting.optionHostVideo;
    mainState.participantEnableVideo.value = meeting.optionParticipantsVideo;
    mainState.enableJBH.value = meeting.optionJbh;
    mainState.enableWaitingRoom.value = meeting.optionWaitingRoom ?? false;
  }

  /// 切换语言
  void changeLocale(Locale locale) {
    currentLocale.value = locale;
    Get.locale = locale;
  }

  bool isTokenExist() {
    // 内存中是否存在
    if (mainState.accessToken.isNotEmpty) {
      return true;
    }
    return false;
  }

  void showToast(String msgKey, int sec) {
    Fluttertoast.showToast(
      msg: msgKey.tr,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  void failAlert(String msgKey, String errMsg) {
    Fluttertoast.showToast(
      msg: '${msgKey.tr} $errMsg',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  // 该方法用于会议列表的UI渲染
  void listHostMeetings() async {
    try {
      isLoading(true);
      var meetingsData =
          await _api.listMeeting(userId: mainState.loginUser.value.id!);
      meetings.assignAll(meetingsData); // 修改meetings 列表数据
    } catch (error) {
      // 处理网络请求失败
      if (kDebugMode) {
        print("[listHostMeetings] failed: $error");
      }
      FlutterLogs.logError("listHostMeetings", "netWorkError", "$error");
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  // 初始化应用
  void sdkInit() {
    ZoomOptions zoomOptions = ZoomOptions(
      domain: APP.domain,
      appKey: APP.appKey,
      appSecret: APP.appSecret,
      jwtToken: APP.jwtToken,
    );

    var zoom = ZoomView();
    zoom.initZoom(zoomOptions).then((results) {
      if (kDebugMode) {
        print("[sdkInit] result: $results");
      }
      FlutterLogs.logInfo("sdkInit", "init_result", "$results");
      if (results[0] == ZoomInitError.ZOOM_ERROR_SUCCESS) {
        // 初始化成功，但自动登录失败
        showToast('toast.init_app_success', 5);

        if (APP.useWebLogin) {
          /// 尝试自动登录 --- 检测是否有登录的token
          if (kDebugMode) {
            print(
                "[sdkInit] initSuccess: begin load user and ready to auto login");
          }
          FlutterLogs.logInfo("sdkInit", "initSuccess",
              "begin load user and ready to auto login");
          // 自动登录成功, 跳转到主页
          loadUserAfterAutoLoginSuccess();
        }
      } else if (results[0] == ZoomInitError.ZOOM_AUTO_LOGIN_SUCCESS) {
        // 自动登录成功, 跳转到主页
        loadUserAfterAutoLoginSuccess();
      } else {
        // 初始化失败
        failAlert('toast.init_app_failed', results.toString());
      }
    });
  }

  // 自动登录成功-获取用户
  void loadUserAfterAutoLoginSuccess() {
    DBUtil.db.getLoginUser().then((dbUser) {
      String? email = dbUser?.email;
      if (email != null) {
        _api.getUserByEmail(email: email).then((user) {
          mainState.loginUser.value = user;
          mainState.accessToken.value = user.apiToken ?? "";
          mainState.zak.value = user.zak ?? "";
          if (kDebugMode) {
            print("[auto-login] Load user success: $user");
          }
          FlutterLogs.logInfo(
              "sdkInit", "loadUserAfterAutoLoginSuccess", "userInfo: $user");
          listHostMeetings();
          // 自动登录成功, 跳转到主页
          // 获取到用户才能跳转！
          isLoggedIn(true);
          Get.toNamed(RouteConfig.main);
          showToast('toast.auto_login_success', 5);
        }).catchError((error) {
          failAlert('toast.auto_login_failed', error.toString());
          if (kDebugMode) {
            print("[auto-login] Error occurred: $error");
          }
          FlutterLogs.logError("sdkInit", "autoLoginFailed", "error: $error");
        });
      } else {
        if (kDebugMode) {
          print("[auto-login] Error occurred: user not found");
        }
        FlutterLogs.logWarn("sdkInit", "autoLoginFailed", "user not found");
      }
    });
  }

  // 登录成功-创建用户
  void createUserAfterLoginSuccess(String email) {
    _api.getUserByEmail(email: email).then((user) {
      mainState.loginUser.value = user;
      DBUtil.db.saveLoginUser(user);

      mainState.accessToken.value = user.apiToken ?? "";
      mainState.zak.value = user.zak ?? "";

      /// 用来开会的token
      if (kDebugMode) {
        print("[first-login] Save user success, userInfo: $user");
      }
      FlutterLogs.logInfo("sdkInit", "firstLoginSuccess", "userInfo: $user");
      listHostMeetings();
    }).catchError((error) {
      throw Exception('Failed to create user: errorCode is $error');
    });
  }

  @Deprecated("这个方法暂时不用")
  void deleteMeetingByNumb(
    String meetingNumb, [
    void Function()? onSuccess,
    void Function(Map<String, dynamic> onFail)? onFail,
  ]) async {
    Object? object = await _api.deleteMeetingByNumb(
        meetingNumb: meetingNumb, hostId: mainState.loginUser.value.id!);
    if (object == null) {
      failAlert('toast.delete_meeting.failed', 'unknown error');
      return;
    }
    if (object is bool) {
      onSuccess?.call();
    } else {
      onFail?.call(object as Map<String, dynamic>);
    }
  }

  /// 根据会议ID删除会议
  void deleteMeetingById(
    String meetingId, [
    void Function()? onSuccess,
    void Function(Map<String, dynamic> onFail)? onFail,
  ]) async {
    Object? object = await _api.deleteMeetingById(
        meetingId: meetingId, hostId: mainState.loginUser.value.id!);
    if (object == null) {
      failAlert('toast.delete_meeting.failed', 'unknown error');
      return;
    }
    if (object is bool) {
      onSuccess?.call();
    } else {
      onFail?.call(object as Map<String, dynamic>);
    }
  }

  /// {"error":{"code":3001,"message":"未找到会议225553555，或者已经过期。"}}
  /// 获取会议
  /// 如果返回的meeting，说明meeting存在
  /// 如果返回的是map，说明请求报错，包含报错信息和报错code
  void getMeetingByNumb(
    String meetingNumb, [
    void Function(Meeting meeting)? onSuccess,
    void Function(Map<String, dynamic> onFail)? onFail,
  ]) async {
    Object? object = await _api.getMeetingByNumb(meetingNumb: meetingNumb);
    if (object == null) {
      failAlert('toast.get_meeting.failed', 'unknown error');
      return;
    }
    if (object is Meeting) {
      onSuccess?.call(object);
    } else {
      onFail?.call(object as Map<String, dynamic>);
    }
  }

  /// 预约会议提交
  void scheduleMeeting(
    ScheduleOptions scheduleOptions, [
    void Function(Meeting)? onSuccess,
    void Function(Map<String, dynamic> onFail)? onFail,
  ]) async {
    Object? object = await _api.scheduleMeeting(scheduleOptions);
    if (object == null) {
      failAlert('toast.schedule_meeting.submit.fail', 'unknown error');
      return;
    }
    if (object is Meeting) {
      // object is meeting
      onSuccess?.call(object);
    } else {
      onFail?.call(object as Map<String, dynamic>);
    }
  }

  /// 编辑会议
  void editMeeting(
    EditOptions editOptions, [
    void Function()? onSuccess,
    void Function(Object onFail)? onFail,
  ]) async {
    Object? object = await _api.editMeeting(editOptions);
    if (object == null) {
      failAlert('toast.edit_meeting.submit.fail', 'unknown error');
      return;
    }
    if (object is bool) {
      onSuccess?.call();
    } else {
      onFail?.call(object as Map<String, dynamic>);
    }
  }

  /// 显示加会密码对话框
  void showJoinPasswordDialog(
      String displayName, String meetingNumb, String meetingPasswd) {
    joinMeetingPasswordTitle.value = 'meeting.pwd.required'.tr;
    Get.dialog(AlertDialog(
      title: Obx(() => Text(joinMeetingPasswordTitle.value)),
      content: TextField(
        controller: joinMeetingPasswordCtrl,
        obscureText: true,
      ),
      actions: [
        TextButton(
          onPressed: mainState.isButtonDisabled.isTrue
              ? null
              : () {
                  if (joinMeetingPasswordCtrl.text == '') {
                    joinMeetingPasswordTitle.value = 'meeting.pwd.required'.tr;
                    return;
                  }
                  if (meetingPasswd == joinMeetingPasswordCtrl.text) {
                    /// 设置按钮不可点击
                    setSubmitButtonDisable();

                    /// 设置按钮3秒后可点击
                    setSubmitButtonAvailable();
                    // 直接加会
                    joinMeeting(meetingPasswd,
                        displayName: displayName, meetingNumb: meetingNumb);
                    // 隐藏弹框
                    joinMeetingPasswordTitle.value = 'meeting.pwd.required'.tr;
                    Get.back();
                  } else {
                    // 显示错误提示
                    joinMeetingPasswordTitle.value = 'meeting.pwd.error'.tr;
                  }
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("btn.continue".tr),
              const SizedBox(width: 4),
              const Icon(Icons.send),
              const SizedBox(width: 8),
            ],
          ),
        )
      ],
    ));
  }

  // 登出
  Future webLogout([void Function()? onSuccess]) async {
    await DBUtil.db.deleteUser();
    mainState.accessToken.value = "";
    mainState.zak.value = "";
    onSuccess?.call();
  }

  /// SDK 退出登录
  void sdkLogout([void Function()? onSuccess]) async {
    if (APP.useWebLogin) {
      webLogout(onSuccess);
      if (kDebugMode) {
        print("[logout] user is logged out!");
      }
      FlutterLogs.logInfo("Logout", "webLogoutSuccess", "user logged out!");
      return;
    }
    var zoom = ZoomView();
    zoom.logoutZoom().then((success) => {
          if (success)
            {
              onSuccess?.call(),
            }
          else
            {
              showToast('logout.fail', 5),
            }
        });
  }

  /// SDK 登录
  void sdkLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    if (APP.useWebLogin) {
      webLogin(email: email, password: password, context: context);
      return;
    }
    var meetingOptions = ZoomMeetingOptions(
      userId: email,
      userPassword: password,
    );
    var zoom = ZoomView();

    zoom.loginZoom(meetingOptions).then((loginResult) {
      if (loginResult[0] == "SDK_ERROR") {
        // sdk初始化失败
        if (kDebugMode) {
          print("[sdkLogin] failed: Init SDK failed");
        }
        FlutterLogs.logError("sdkLogIn", "SDKError", "Init SDK failed");

        showToast('login.fail', 5);
        CommonUI.showBanner(context, "message.app_fail_reconnect".tr, () {
          sdkInit();
        });
      } else if (loginResult[0] == "LOGIN_ERROR") {
        // 登录失败
        if (loginResult[1] == ZoomError.ZOOM_AUTH_ERROR_WRONG_ACCOUNTLOCKED) {
          if (kDebugMode) {
            print("[sdkLogin] failed: Multiple Failed Login Attempts");
          }
          FlutterLogs.logError(
              "sdkLogIn", "SDKError", "Multiple Failed Login Attempts");
          return;
        }
        if (kDebugMode) {
          print("[sdkLogin] failed: ${loginResult[1]}");
        }
        FlutterLogs.logError("sdkLogIn", "SDKError", "${loginResult[1]}");
        showToast('login.fail', 5);
        CommonUI.showBanner(context, "message.app_login_fail".tr, null);
      } else {
        // 登录成功
        createUserAfterLoginSuccess(loginResult[1]);
        isLoggedIn(true);
        showToast('login.success', 5);
        // 跳转到主页
        Get.toNamed(RouteConfig.main);
      }
    }).catchError((error) {
      showToast('login.fail', 5);
      if (kDebugMode) {
        print(error);
      }
      FlutterLogs.logError("sdkLogIn", "SDKError", "$error");
    });
  }

  /// web 登录
  void webLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    var zoom = ZoomView();
    zoom.isSdkInit().then((success) async {
      /// sdk初始化失败
      if (!success) {
        showToast('login.fail', 5);
        CommonUI.showBanner(context, "message.app_fail_reconnect".tr, () {
          sdkInit();
        });
        return;
      }
      // 获取登录状态
      bool loginSuccess = await _api.webLogin(email: email, password: password);

      /// 登录失败
      if (!loginSuccess) {
        if (!context.mounted) return;
        CommonUI.showBanner(
            context, "message.app_login_fail_userpass_error".tr, null);
        return;
      }

      // 登录成功
      createUserAfterLoginSuccess(email);
      isLoggedIn(true);
      showToast('login.success', 5);
      // 跳转到主页
      Get.toNamed(RouteConfig.main);
    }).catchError((error) {
      showToast('login.fail', 5);
      if (kDebugMode) {
        print("[webLogin] failed：$error");
      }
      FlutterLogs.logError("webLogIn", "initSDKError", "$error");
    });
  }

  /// 开始即时会议，仅限于免登录用户
  void startInstantMeetingWithoutLogin() {
    /// 不使用PMI开会
    String meetingTopic = "${mainState.loginUser.value.displayName}的即时会议";
    if (!mainState.showEnablePMIBtn.value) {
      /// 创建即时会议
      ScheduleOptions scheduleOpt = ScheduleOptions(
        mainState.loginUser.value.id!,
        meetingTopic,
        '', // 起始时间默认当前时间
        type: 1,
        optionJbh: true,
      );
      onSuccess(Meeting meeting) {
        // 开会
        if (kDebugMode) {
          print(
              '[start-meeting] create instant meeting ${meeting.meetingNumb}');
        }
        FlutterLogs.logInfo(
            "startMeeting", "createInstMeeting", "mn: ${meeting.meetingNumb}");
        startInstantMeeting(
            meetingNumb: meeting.meetingNumb, meetingTopic: meetingTopic);
      }

      onFail(error) {
        Get.snackbar(
          "snack-bar.message_warning".tr,
          "toast.schedule_meeting.submit.fail".tr,
          colorText: Colors.white,
          backgroundColor: Colors.brown,
          duration: const Duration(seconds: 5),
        );
      }

      scheduleMeeting(scheduleOpt, onSuccess, onFail);
      return;
    }
    // 使用PMI开会
    if (kDebugMode) {
      print('[start-meeting] start with pmi');
    }
    FlutterLogs.logInfo("startMeeting", "usePMI", "start meeting with PMI");
    startInstantMeeting(
        meetingNumb: mainState.loginUser.value.pmi.toString(),
        meetingTopic: meetingTopic);
  }

// 即时会议
  void startInstantMeeting({required meetingNumb, required meetingTopic}) {
    bool isMeetingEnded(String status) {
      var result = false;
      if (Platform.isAndroid) {
        result = status == "MEETING_STATUS_DISCONNECTING" ||
            status == "MEETING_STATUS_FAILED";
      } else {
        result = status == "MEETING_STATUS_IDLE";
      }
      return result;
    }

    var meetingOptions = ZoomMeetingOptions(
      disableDialIn: "false",
      disableDrive: "true",
      disableInvite: "false",
      disableShare: "false",
      disableTitlebar: "false",
      viewOptions: "false",
      noAudio: "false",
      noDisconnectAudio: "false",
      enableVideo: (!mainState.showEnableVideoBtn.value).toString(),
      meetingId: meetingNumb,
      zoomAccessToken: mainState.zak.value,
      zoomToken: mainState.accessToken.value,
      displayName: meetingTopic,
      userId: mainState.loginUser.value.id,
    );

    // 是否开启PMI会议
    if (mainState.showEnablePMIBtn.value) {
      meetingOptions.pmi = mainState.loginUser.value.pmi.toString();
    }

    var zoom = ZoomView();
    zoom.onMeetingStatus().listen((status) {
      if (kDebugMode) {
        print("${"[listenMeetingStatusForStart] start result: " + status[0]} " +
            status[1]);
      }
      FlutterLogs.logInfo("listenMeetingStatusForStart", "getResult",
          "s0: ${status[0]} s1: ${status[1]}");

      if (isMeetingEnded(status[0])) {
        if (kDebugMode) {
          print("[listenMeetingStatusForStart] meeting ended");
        }
        FlutterLogs.logInfo(
            "listenMeetingStatusForStart", "meetingEnd", "meeting end");
        // timer.cancel();
      }
      if (status[0] == "MEETING_STATUS_INMEETING") {
        zoom.meetingDetails().then((meetingDetailsResult) {
          if (kDebugMode) {
            print(
                "[listenMeetingStatusForStart] meeting details: $meetingDetailsResult");
          }
          FlutterLogs.logInfo("listenMeetingStatusForStart",
              "meetingDetailResult", "$meetingDetailsResult");
        });
      }
    });

    zoom.startInstantMeeting(meetingOptions).then((result) {
      if (kDebugMode) {
        print("${"[startInstantMeeting] result:" + result[0]} " + result[1]);
      }
      FlutterLogs.logInfo("startInstantMeeting", "getResult",
          "s0: ${result[0]} s1: ${result[1]}");

      if (result[0] == "SDK_ERROR") {
        // SDK INIT FAILED
        if (kDebugMode) {
          print("[startInstantMeeting] failed: Init SDK failed");
        }
        FlutterLogs.logError(
            "startInstantMeeting", "meetingDetailResult", "Init SDK failed");
        return;
      } else if (result[0] == "LOGIN_ERROR") {
        // LOGIN FAILED - WITH ERROR CODES
        if (result[1] == ZoomError.ZOOM_AUTH_ERROR_WRONG_ACCOUNTLOCKED) {
          if (kDebugMode) {
            print(
                "[startInstantMeeting] failed: Multiple failed login attempts");
          }
          FlutterLogs.logError("startInstantMeeting", "LoginFailed",
              "Multiple failed login attempts");
        }
        if (kDebugMode) {
          print("startInstantMeeting other login error: ${result[1]}");
        }
        FlutterLogs.logError(
            "startInstantMeeting", "OtherLoginError", "${result[1]}");
        return;
      } else {
        // LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
        if (kDebugMode) {
          print("[startInstantMeeting] success");
        }
        FlutterLogs.logInfo(
            "startInstantMeeting", "MeetingStarted", "meeting started");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('[startInstantMeeting] Error Occurs: $error');
      }
      FlutterLogs.logError(
          "startInstantMeeting", "OtherErrorWhenStartMeeting", "$error");
    });
  }

// 开始预约会议
  void startWithMeetingNumb(
      {required String meetingNumb, required String meetingTopic}) {
    bool isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid) {
        result = status == "MEETING_STATUS_DISCONNECTING" ||
            status == "MEETING_STATUS_FAILED";
      } else {
        result = status == "MEETING_STATUS_IDLE";
      }
      return result;
    }

    var meetingOptions = ZoomMeetingOptions(
      userId: mainState.loginUser.value.id,
      meetingId: meetingNumb,
      disableDialIn: "false",
      disableDrive: "true",
      disableInvite: "false",
      disableShare: "false",
      disableTitlebar: "false",
      viewOptions: "false",
      noAudio: "false",
      noDisconnectAudio: "false",
      zoomAccessToken: mainState.zak.value,
      zoomToken: mainState.accessToken.value,
      displayName: meetingTopic,
    );

    var zoom = ZoomView();
    zoom.onMeetingStatus().listen((status) {
      if (kDebugMode) {
        print("${"[listenMeetingStatus] result " + status[0]} " + status[1]);
      }
      FlutterLogs.logInfo("listenMeetingStatus", "getResult",
          "s0: ${status[0]} s1: ${status[1]}");
      if (isMeetingEnded(status[0])) {
        if (kDebugMode) {
          print("[listenMeetingStatus] Meeting ended");
        }
        FlutterLogs.logInfo("listenMeetingStatus", "meetingEnd",
            "s0: ${status[0]} s1: ${status[1]}");
        // timer.cancel();
      }
      if (status[0] == "MEETING_STATUS_INMEETING") {
        zoom.meetingDetails().then((meetingDetailsResult) {
          if (kDebugMode) {
            print(
                "[listenMeetingStatus] meeting details: $meetingDetailsResult");
          }
          FlutterLogs.logInfo("listenMeetingStatus", "meetingDetailResult",
              "$meetingDetailsResult");
        });
      }
    });

    zoom.startMeetingWithNumber(meetingOptions).then((result) {
      if (kDebugMode) {
        print("${"[startMeetingWithNumber] start result: " + result[0]} " +
            result[1]);
        FlutterLogs.logInfo("startMeetingWithNumber", "getResult",
            "s0: ${result[0]} s1: ${result[1]}");
      }
      if (result[0] == "SDK_ERROR") {
        // SDK INIT FAILED
        if (kDebugMode) {
          print("[startMeetingWithNumber] failed: Init SDK failed");
        }
        FlutterLogs.logError(
            "startMeetingWithNumber", "meetingDetailResult", "Init SDK failed");
        return;
      } else {
        // LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
        if (kDebugMode) {
          print("[startMeetingWithNumber] success");
        }
        FlutterLogs.logInfo(
            "startMeetingWithNumber", "MeetingStarted", "meeting started");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("[startMeetingWithNumber] failed: " + error);
      }
      FlutterLogs.logError(
          "startMeetingWithNumber", "OtherErrorWhenStartMeeting", "$error");
    });
  }

  /// 加会
  void joinMeeting(String meetingPass,
      {required String displayName, required String meetingNumb}) {
    bool isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid) {
        result = status == "MEETING_STATUS_DISCONNECTING" ||
            status == "MEETING_STATUS_FAILED";
      } else {
        result = status == "MEETING_STATUS_IDLE";
      }
      return result;
    }

    var meetingOptions = ZoomMeetingOptions(
        userId: displayName,
        meetingId: meetingNumb,
        meetingPassword: meetingPass,

        /// pass meeting password for join meeting only
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "false",
        disableTitlebar: "false",
        viewOptions: "false",
        noAudio: "false",
        enableVideo: (!mainState.keepCameraOff.value).toString(),
        noDisconnectAudio: (!mainState.autoConnectAudio.value).toString());

    var zoom = ZoomView();
    zoom.onMeetingStatus().listen((status) {
      if (isMeetingEnded(status[0])) {
        if (kDebugMode) {
          print("[listenMeetingStatusForJoin] Meeting ended");
        }
        FlutterLogs.logInfo(
            "listenMeetingStatusForJoin", "meetingEnd", "meeting end");
        timer.cancel();
      }
      if (status[0] == "MEETING_STATUS_INMEETING") {
        zoom.meetingDetails().then((meetingDetailsResult) {
          if (kDebugMode) {
            print(
                "[listenMeetingStatusForJoin] meeting details: $meetingDetailsResult");
          }
          FlutterLogs.logInfo("listenMeetingStatusForJoin", "meetingDetail",
              "$meetingDetailsResult");
        });
      }
    });

    /// 60s 请求一次meeting状态
    zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
      timer = Timer.periodic(const Duration(seconds: 60), (timer) {
        zoom.meetingStatus(meetingOptions.meetingId!).then((status) {
          if (kDebugMode) {
            print("${"[joinMeeting] result: " + status[0]} - " + status[1]);
          }
          FlutterLogs.logInfo("joinMeeting", "meetingJoinResult",
              "s0: ${status[0]}} s1: ${status[1]}}");
        });
      });
    });
  }

  /// 选择开会时间
  void showChoseScheduleDatePicker(BuildContext ctx, String locale) {
    // 起始日期
    var now = DateTime.now();
    // 最大日期限制为90天内，无法预约90天后的会议
    var maxDateTime = now.add(const Duration(days: 90));

    var selectLocale = DateTimePickerLocale.zh_cn;
    var dateFormat = "yyyy-M月-d日  H时:m分";
    bool isLangUS = locale == 'en';
    if (isLangUS) {
      selectLocale = DateTimePickerLocale.en_us;
      dateFormat = 'yyyy-MM-dd  HH:mm';
    }

    DatePicker.showDatePicker(
      ctx,
      minDateTime: now,
      //起始日期
      maxDateTime: maxDateTime,
      //终止日期
      initialDateTime: DateTime.now(),
      dateFormat: dateFormat,
      //显示格式
      locale: selectLocale,
      //语言
      pickerTheme: const DateTimePickerTheme(
        showTitle: true,
      ),
      pickerMode: DateTimePickerMode.datetime,
      // show TimePicker
      onCancel: () {
        debugPrint('onCancel');
        // Get.back();
      },
      onChange: (dateTime, List<int> index) {
        choseScheduleDateTime.value = dateTime;
      },
      onConfirm: (dateTime, List<int> index) {
        choseScheduleDateTime.value = dateTime;
      },
    );
  }

  /// 选择会议时长
  void showChoseTimePicker(BuildContext ctx, String locale) {
    // 初始化最小1小时
    var now = DateTime(0, 0, 0, 1);
    // 最长可选6小时
    var oneDay = now.add(const Duration(hours: 6));

    String format = 'H时 m分';
    bool isLangUS = locale == 'en';
    if (isLangUS) {
      format = 'Hh m';
    }
    DatePicker.showDatePicker(
      ctx,
      minDateTime: now,
      maxDateTime: oneDay,
      initialDateTime: now,
      dateFormat: format,
      pickerMode: DateTimePickerMode.time,
      pickerTheme: DateTimePickerTheme(
        title: Container(
          decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
          width: double.infinity,
          height: 40.0,
          alignment: Alignment.center,
          child: Text('meeting.schedule.timepicker'.tr),
        ),
        titleHeight: 40.0,
      ),
      onCancel: () {
        // debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        choseScheduleDuration.value = dateTime;
      },
      onConfirm: (dateTime, List<int> index) {
        choseScheduleDuration.value = dateTime;
      },
    );
  }
}
