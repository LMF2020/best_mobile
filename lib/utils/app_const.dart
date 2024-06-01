import 'dart:async';

class APP {
  static const domain = "best-meeting.com";
  static const appKey = "Ah4nVeJFffzzCO2cN2WqWfPCwxiiQwFqoLdL";
  static const appSecret = "ZUVzFeB8f3Dhxx7QJ318n6UFzW6EYBgDikp4";
  static const apiKey = "mUf7hfuHQ1KyZExu6SI2Kg";
  static const apiSecret = "mAoycBUMyeUbCMM4um4cqaDCKLNYWmZQhWpy";
  static const jwtToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBLZXkiOiJBaDRuVmVKRmZmenpDTzJjTjJXcVdmUEN3eGlpUXdGcW9MZEwiLCJpYXQiOjE3MDgxODEwNTMsImV4cCI6MjMzODkwMTA1MywidG9rZW5FeHAiOjIzMzg5MDEwNTN9.sKZAFH9T_L7m6Bsy-ZzB6KEnYK0OBqyjxk4KwVO6Dv4";

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
