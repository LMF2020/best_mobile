import 'package:sparkmob/utils/common_utils.dart';

class Meeting {
  final String uuid;
  final String? topic;
  final String meetingNumb;
  final String? startTimeUTC; // yyyy-MM-dd'T'HH:mm:ss'Z'
  final String? startTimeYMD;
  final String? startTimeHMS;
  final DateTime? startTimeDate;
  final int? duration;
  final String? password;
  final int type;
  final String hostId;
  final String timezone;
  final bool optionUsePmi;
  final bool optionHostVideo;
  final bool optionParticipantsVideo;
  final bool optionJbh;
  final bool? optionWaitingRoom;

  Meeting({
    required this.uuid,
    required this.topic,
    required this.meetingNumb,
    this.startTimeUTC,
    this.startTimeDate,
    this.startTimeYMD,
    this.startTimeHMS,
    required this.type,
    this.password,
    this.duration,
    required this.timezone,
    required this.hostId,
    required this.optionUsePmi,
    required this.optionHostVideo,
    required this.optionParticipantsVideo,
    required this.optionJbh,
    this.optionWaitingRoom,
  });

  @override
  String toString() {
    return 'Meeting{id: $uuid, topic: $topic, meetingNumb: $meetingNumb, startTime: $startTimeUTC}';
  }

  factory Meeting.fromJson(Map<String, dynamic> json) {
    var meeting = Meeting(
      uuid: json['uuid'],
      topic: json['topic'],
      meetingNumb: json['id'].toString(),
      // 周期性会议 start_time 为 null
      startTimeUTC: json['start_time'] ?? "",
      startTimeDate: Utils.formatStringToDateTime(json['start_time']),
      // 转化为当前local时区的时间
      startTimeYMD: Utils.formatDateTimeToYYYYMMDD(
          json['start_time'], json['timezone'], "yyyy-MM-dd"),
      startTimeHMS: Utils.formatDateTimeToYYYYMMDD(
          json['start_time'], json['timezone'], "HH:mm"),
      type: json['type'],
      password: json['password'],
      duration: json['duration'],
      hostId: json['host_id'],
      timezone: json['timezone'],
      optionUsePmi: json['option_use_pmi'],
      optionHostVideo: json['option_host_video'],
      optionJbh: json['option_jbh'],
      optionWaitingRoom: json['option_waiting_room'] ?? false,
      optionParticipantsVideo: json['option_participants_video'],
    );
    return meeting;
  }

/*
  {
            "uuid": "ckiWJsoDQo2hzzWPtA15SQ==",
            "id": 895826549,
            "host_id": "UFrUJUJfR_qc4Fp6gfV3nw",
            "topic": "2023股东大会",
            "password": "123",
            "h323_password": "123",
            "status": 0,
            "option_jbh": false,
            "option_start_type": "video",
            "option_host_video": false,
            "option_participants_video": false,
            "option_cn_meeting": false,
            "option_enforce_login": false,
            "option_enforce_login_domains": "",
            "option_in_meeting": false,
            "option_audio": "voip",
            "option_alternative_hosts": "",
            "option_use_pmi": false,
            "type": 2,
            "start_time": "2023-08-31T06:00:00Z",
            "duration": 60,
            "timezone": "Asia/Shanghai",
            "start_url": "https://sso.meetspark.com.cn/s/895826549?zak=eyJ6bV9za20iOiJ6bV9vMm0iLCJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJjbGllbnQiLCJ1aWQiOiJVRnJVSlVKZlJfcWM0RnA2Z2ZWM253IiwiaXNzIjoid2ViIiwic3R5IjoxMDAsImNsdCI6MCwic3RrIjoiUzZCV3RnZ3NJOGpCWGdSd0tsZDlUT1JkTE82YUw1Z2JJSUc3dW5JNGNXNC5CZ1VnTUdkRFEwSlZhbWw0T0ROTWRXTnNSM295VVdWRVN6SkRTMEZTWVU5TGMyOUFNRGM0T1Raa05qSTVaRFE0TURJMU56azJaR000WXpRM00yRTFZakZoTURJellqQmhZelF4Tm1Nd05USTVNakl6WVdJMVptUm1OVGN3TldNeVlUWTRaUUFNTTBOQ1FYVnZhVmxUTTNNOUFBQSIsImV4cCI6MTY5MzA3MTg5NywiaWF0IjoxNjkzMDY0Njk3LCJhaWQiOiJpdUl1TXlqeVRseTFsMHhaekM5ckRBIiwiY2lkIjoiIn0.SbJQaf9UNrCC38EdJ98VVU33tmyMlEyDJB-EaQy-8y8",
            "join_url": "https://sso.meetspark.com.cn/j/895826549?pwd=RUVDTmxQeXhMQTVyL3VFandUUUphUT09",
            "created_at": "2023-08-26T11:08:25Z"
        },
   */
}
