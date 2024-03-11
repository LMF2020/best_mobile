/// 预约会议参数
class ScheduleOptions {
  final String hostId;
  final String topic; // 会议主题
  final String startTime;
  final int duration;
  final int type;
  final bool optionUsePmi;
  final String password;
  final bool optionHostVideo;
  final bool optionParticipantsVideo;
  final bool optionJbh;
  final String? timeZone;
  final bool optionWaitingRoom;

  ScheduleOptions(
    this.hostId,
    this.topic,
    this.startTime, {
    this.password = "",
    this.duration = 60,
    this.type = 2,
    this.optionUsePmi = false,
    this.optionHostVideo = false,
    this.optionParticipantsVideo = false,
    this.optionJbh = false,
    this.timeZone = "Asia/Shanghai",
    this.optionWaitingRoom = false,
  });

  @override
  String toString() {
    return 'ClassName($hostId, $topic, $startTime, $password, $duration, $optionUsePmi, $optionHostVideo)';
  }
}
