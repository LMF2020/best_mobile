import 'dart:async';

class APP {
  static const domain = "meeting.sanyuanshi.com";
  static const appKey = "QwPvmE3H3leyNzGCwLO5sAVBDpHQ0v0Sod00";
  static const appSecret = "lS8Wol1rerbPf1KpgVW4gddo0pLJDXDfEuL8";
  static const apiKey = "Ihp-yFuWRQav1rjH_kK9mg";
  static const apiSecret = "yCq1rLXqyzLIDsObGerkGD1O6mKBsgr9Sdev";
  static const jwtToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBLZXkiOiJRd1B2bUUzSDNsZXlOekdDd0xPNXNBVkJEcEhRMHYwU29kMDAiLCJpYXQiOjE3MTg1MTA3ODIsImV4cCI6MjM0OTIzMDc4MiwidG9rZW5FeHAiOjIzNDkyMzA3ODJ9.VB48MCB3vAnA1Kap_px7u3n4I0Uu1-ILlR9HQit-Kac";

  static const String disclaimerLoginPageAgreeTerm = "我已同意";
  static const String disclaimerJoinPageAgreeTerm = "点击 \"加入\", 即表示您同意我们的";
  static const String disclaimerPolicyContent = "《用户协议》";
  static const String disclaimerPolicyContentUrl = '';
  // 'https://$domain/terms/policy';

  static const String disclaimerPrivacyContent = "《隐私政策》";
  static const String disclaimerPrivacyContentUrl = '';
  // 'https://$domain/terms/privacy';

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
