import 'package:flutter_test/flutter_test.dart';
import 'package:sparkmob/api/http_api.dart';
import 'package:sparkmob/model/meeting.dart';
import 'package:sparkmob/model/user.dart';

void main() {
  test('listMeetingAPI', () async {
    HttpsAPI repo = HttpsAPI();
    List<Meeting> list = await repo.listMeeting(userId: 'xxxxxx');
    print(list);
  });

  test('getUserByEmail', () async {
    HttpsAPI repo = HttpsAPI();
    User user = await repo.getUserByEmail(email: 'josh@meetspark.com.cn');
    print(user);
  });
}
