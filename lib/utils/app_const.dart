import 'dart:async';

class APP {
  static const domain = "meeting.bjrun.com";
  static const appKey = "7EaTl228EKTubf5xdiIaW5WrcVVTFCPNwpRE";
  static const appSecret = "BP7DQYlWI1YCCpWFip8oAH2YPPODf0as6V3C";
  static const apiKey = "jpFpObtBQ4SmzABVWspbjg";
  static const apiSecret = "qFITAu00ROx1b0jKEC70TqPOcZvZ9UXFSwaw";
  static const jwtToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBLZXkiOiI3RWFUbDIyOEVLVHViZjV4ZGlJYVc1V3JjVlZURkNQTndwUkUiLCJpYXQiOjE3MTcyNDgyNjAsImV4cCI6MjM0Nzk2ODI2MCwidG9rZW5FeHAiOjIzNDc5NjgyNjB9.KA7Q0z6Fnjhsm1VP2VqULGO0aeihuVo_9knFTK2B_Fs";

  static const String disclaimerLoginPageAgreeTerm = "我已同意";
  static const String disclaimerJoinPageAgreeTerm = "点击 \"加入\", 即表示您同意我们的";
  static const String disclaimerPolicyContent = "《用户协议》";
  static const String disclaimerPolicyContentUrl =
      'https://$domain/terms/policy';

  static const String disclaimerPrivacyContent = "《隐私政策》";
  static const String disclaimerPrivacyContentUrl =
      'https://$domain/terms/privacy';

  /// 是否开启隐私声明选项
  static const bool showPolicyTerms = true;

  /// 是否使用sdk登录，sdk 5.9.6 以后无法使用sdkLogin
  static const bool useWebLogin = true;

  static const bool toJoinPageAfterAppInit = false;

  // 获取设备唯一ID
  static String? deviceId = "";
  static Timer? currentTimer;

  /// 定义用户名和密码的key
  static const String keyUserName = "username";
  static const String keyPassword = "pwd";
  static const String keyJoinDisplayName = "joinDisplayName";
  static const String keyMeetingHistory = "meetingHistory";
  static const String clientVerAndroid = "v1.0.0";
  static const String clientVerIOS = "v1.0.0";
}
