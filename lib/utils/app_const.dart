import 'dart:async';

class APP {
  static const domain = "teachers-here.tw";
  static const appKey = "cBNn44FBO1661YSRYA3YBVpiPqMS3rOZLBeO";
  static const appSecret = "9oO3Tv2ZlDWV6OGn7PxxYqM8aKR0ZUpTwxvj";
  static const apiKey = "yzNFKCF4TF2DdK9aK9V12g";
  static const apiSecret = "Qzu4BFdzk38jIMf0K6gQRyU8gezoYlPHHZkN";
  static const jwtToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBLZXkiOiJjQk5uNDRGQk8xNjYxWVNSWUEzWUJWcGlQcU1TM3JPWkxCZU8iLCJpYXQiOjE3MTYwMzUzMjQsImV4cCI6MjM0Njc1NTMyNCwidG9rZW5FeHAiOjIzNDY3NTUzMjR9.DObERzCcT97ZB8UFJ1JZKz9hNcXcJcdJHAHPkZEPTRQ";
  static const String disclaimerLoginPageAgreeTerm = "我已同意";
  static const String disclaimerJoinPageAgreeTerm = "點擊 \"加入\", 即表示您同意我們的";
  static const String disclaimerPolicyContent = "《使用者協議》";
  static const String disclaimerPolicyContentUrl =
      'https://$domain/terms/policy';

  static const String disclaimerPrivacyContent = "《隱私政策》";
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
