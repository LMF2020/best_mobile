class APP {
  // dryrun env 150
  // static const domain = "dev.meetspark.com.cn";
  // static const appKey = "Rl1EsPk3BAfQ0XGGQPSM0xQjfQmOcbgeXanb";
  // static const appSecret = "8VYeR02szhApsn5kHFPliOFYnxflHh9zAy3r";
  // static const apiKey = "25x_ffhVRTmK_zvM-rwtVg";
  // static const apiSecret = "oEm7ShhBUHASjGc9zkNBohk9ObMFFxMaLbQW";
  // static const jwtToken =
  //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBLZXkiOiJSbDFFc1BrM0JBZlEwWEdHUVBTTTB4UWpmUW1PY2JnZVhhbmIiLCJpYXQiOjE2ODc3MDYwNTksImV4cCI6MjMxODQyNjA1OSwidG9rZW5FeHAiOjIzMTg0MjYwNTl9.J9yJ7Cq8DMZRli-uLsbn1Pt91g-Oen_ei_z0yF5x3Mc";

  static const domain = "best-meeting.com";
  static const appKey = "Ah4nVeJFffzzCO2cN2WqWfPCwxiiQwFqoLdL";
  static const appSecret = "ZUVzFeB8f3Dhxx7QJ318n6UFzW6EYBgDikp4";
  static const apiKey = "mUf7hfuHQ1KyZExu6SI2Kg";
  static const apiSecret = "mAoycBUMyeUbCMM4um4cqaDCKLNYWmZQhWpy";
  // static const jwtToken =
  //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBLZXkiOiJBaDRuVmVKRmZmenpDTzJjTjJXcVdmUEN3eGlpUXdGcW9MZEwiLCJpYXQiOjE2ODc3MDYwNTksImV4cCI6MTczNDQyNTA1OSwidG9rZW5FeHAiOjIzMTg0MjYwNTl9.ESQN8aipnq91kwgNdWS3yDw_-05W5BxrPuWXBPQtL6Q";
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
}
