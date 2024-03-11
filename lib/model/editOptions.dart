/// 编辑会议参数
class EditOptions {
  final String meetingId; // 必填
  final String meetingNumb; // 必填
  final String hostId; // 必填
  final String topic; // 必填
  final String startTime;
  final int duration;
  final int type;
  final bool optionUsePmi;
  final String password;
  final bool optionHostVideo;
  final bool optionParticipantsVideo;
  final bool optionJbh;
  final bool? optionWaitingRoom;
  final String timezone;

  EditOptions(
    this.meetingId,
    this.meetingNumb,
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
    this.optionWaitingRoom = false,
    this.timezone = "Asia/Shanghai",
  });

  @override
  String toString() {
    return 'ClassName($meetingId, $meetingNumb, $hostId, $topic, $startTime, $password, $duration, $optionUsePmi, $optionHostVideo)';
  }
}
