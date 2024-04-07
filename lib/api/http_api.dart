import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:sparkmob/model/meeting.dart';
import 'package:sparkmob/model/user.dart';
import '../model/editOptions.dart';
import '../model/scheduleOptions.dart';
import '../utils/app_const.dart';
import '../utils/dio.dart';

class HttpsAPI {
  /// 用户API登录
  Future<bool> webLogin(
      {required String email, required String password}) async {
    try {
      var response = await dio.post(
        '/signin',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode == 200 &&
          response.data["status"] &&
          response.data["errorCode"] == 0) {
        // 登录成功
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      FlutterLogs.logError("best", "weblogin", "$e");
      return false;
    }
  }

  /// 通过用户ID获取会议列表
  Future<List<Meeting>> listMeeting({required String userId}) async {
    try {
      if (kDebugMode) {
        print('[listMeeting request] userId: $userId, apiKey: ${APP.apiKey}');
      }
      var response = await dio.post(
        '/v1/meeting/list',
        data: {
          'api_key': APP.apiKey,
          'api_secret': APP.apiSecret,
          'host_id': userId,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      Map<String, dynamic> responseData = response.data;
      if (response.statusCode == 200) {
        if (responseData.containsKey('error')) {
          if (kDebugMode) {
            print('[listMeeting] error: $responseData');
          }
          FlutterLogs.logError("listMeeting", "responseError", '$responseData');
          throw Exception(
              'Failed to list meeting because errorCode is $responseData');
        }
        List<dynamic> listData = responseData['meetings'];
        List<Meeting> meetings = [];
        for (var item in listData) {
          // 创建 Meeting 对象并添加到列表
          Meeting meeting = Meeting.fromJson(item);
          meetings.add(meeting);
        }
        return meetings;
      } else {
        throw Exception('Failed to list meetings, error occurs $responseData');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// 通过邮箱获取用户信息
  Future<User> getUserByEmail({required String email}) async {
    try {
      var response = await dio.post(
        '/v1/user/getbyemail',
        data: {
          'api_key': APP.apiKey,
          'api_secret': APP.apiSecret,
          'email': email,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      Map<String, dynamic> responseData = response.data;
      if (response.statusCode == 200) {
        if (responseData.containsKey('error')) {
          print('[getUserByEmail] error: $responseData');
          throw Exception(
              'Failed to load user because errorCode is $responseData');
        }

        User user = User.fromMap(responseData);
        return user;
      } else {
        // 处理请求失败的情况
        throw Exception('Failed to load user, error occurs $responseData');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// 删除会议
  @Deprecated("======这个方法暂时不用=====")
  Future<Object?> deleteMeetingByNumb(
      {required String meetingNumb, required String hostId}) async {
    try {
      var response = await dio.post(
        '/v1/meeting/delete',
        data: {
          'api_key': APP.apiKey,
          'api_secret': APP.apiSecret,
          'host_id': hostId,
          'number': meetingNumb,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      Map<String, dynamic> responseData = response.data;
      if (response.statusCode == 200) {
        if (responseData.containsKey('error')) {
          if (kDebugMode) {
            print('[deleteMeetingByNumb] error: $responseData');
          }
          FlutterLogs.logError(
              "deleteMeetingByNumb", "responseError", '$responseData');
          Map<String, dynamic> errorMap = responseData['error'];
          return errorMap;
        }
        return true;
      } else {
        // 处理请求失败的情况
        if (kDebugMode) {
          print('Failed to delete meeting, error occurs $responseData');
        }
        FlutterLogs.logError("deleteMeetingByNumb",
            "responseStatusOtherThan200", '$responseData');
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('deleteMeetingByNumb failed $e');
      }
      FlutterLogs.logError("deleteMeetingByNumb", "UnknownCase", '$e');
      throw Exception('Error: $e');
    }
  }

  /// 删除会议
  Future<Object?> deleteMeetingById(
      {required String meetingId, required String hostId}) async {
    try {
      var response = await dio.post(
        '/v1/meeting/delete',
        data: {
          'api_key': APP.apiKey,
          'api_secret': APP.apiSecret,
          'host_id': hostId,
          'id': meetingId,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      Map<String, dynamic> responseData = response.data;
      if (response.statusCode == 200) {
        if (responseData.containsKey('error')) {
          if (kDebugMode) {
            print('[deleteMeetingById] error: $responseData');
          }
          FlutterLogs.logError(
              "deleteMeetingById", "responseError", '$responseData');
          Map<String, dynamic> errorMap = responseData['error'];
          return errorMap;
        }
        return true;
      } else {
        // 处理请求失败的情况
        if (kDebugMode) {
          print('Failed to delete meeting, error occurs $responseData');
        }
        FlutterLogs.logError(
            "deleteMeetingById", "responseStatusOtherThan200", '$responseData');
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('deleteMeetingById failed $e');
      }
      FlutterLogs.logError("deleteMeetingById", "UnknownCase", '$e');
      throw Exception('Error: $e');
    }
  }

  /**
   * {"error":{"code":3001,"message":"未找到会议225553555，或者已经过期。"}}
   */

  /// 根据会议号获取会议
  Future<Object?> getMeetingByNumb({required String meetingNumb}) async {
    try {
      var response = await dio.post(
        '/v1/meeting/get',
        data: {
          'api_key': APP.apiKey,
          'api_secret': APP.apiSecret,
          'id': meetingNumb,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      Map<String, dynamic> responseData = response.data;
      if (response.statusCode == 200) {
        if (responseData.isEmpty) {
          return null;
        }
        if (responseData.containsKey('error')) {
          if (kDebugMode) {
            print('[getMeetingByNumb] error: $responseData');
          }
          FlutterLogs.logError(
              "getMeetingByNumb", "responseError", '$responseData');
          Map<String, dynamic> errorMap = responseData['error'];
          return errorMap;
        }
        return Meeting.fromJson(responseData);
      } else {
        // 处理请求失败的情况
        if (kDebugMode) {
          print('Failed to get meeting, error occurs $responseData');
        }
        FlutterLogs.logError(
            "getMeetingByNumb", "responseStatusOtherThan200", '$responseData');
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get meeting: final error is $e');
      }
      FlutterLogs.logError("getMeetingByNumb", "UnknownCase", '$e');
      return null;
    }
  }

  /// 预约会议
  Future<Object?> scheduleMeeting(ScheduleOptions scheduleOptions) async {
    try {
      var response = await dio.post(
        '/v1/meeting/create',
        data: {
          'api_key': APP.apiKey,
          'api_secret': APP.apiSecret,
          'host_id': scheduleOptions.hostId,
          'timezone': scheduleOptions.timeZone,
          'topic': scheduleOptions.topic,
          'start_time': scheduleOptions.startTime,
          'duration': scheduleOptions.duration,
          'type': scheduleOptions.type,
          'option_use_pmi': scheduleOptions.optionUsePmi,
          // 使用个人会议号
          'password': scheduleOptions.password,
          // 需要会议密码
          'option_host_video': scheduleOptions.optionHostVideo,
          // 主持人视频开启
          'option_participants_video': scheduleOptions.optionParticipantsVideo,
          // 参会者视频开启
          'option_jbh': scheduleOptions.optionJbh,
          // 允许参会者随时加会
          'option_waiting_room': scheduleOptions.optionWaitingRoom,
          // 启用等候室
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      Map<String, dynamic> responseData = response.data;
      if (response.statusCode == 200) {
        if (responseData.containsKey('error')) {
          if (kDebugMode) {
            print('[scheduleMeeting] error: $responseData');
          }
          FlutterLogs.logError(
              "scheduleMeeting", "responseError", '$responseData');
          Map<String, dynamic> errorMap = responseData['error'];
          return errorMap;
        }
        return Meeting.fromJson(response.data);
      } else {
        // 处理请求失败的情况
        if (kDebugMode) {
          print('Failed to schedule meeting, error occurs $responseData');
        }
        FlutterLogs.logError(
            "scheduleMeeting", "responseStatusOtherThan200", '$responseData');
        return null;
      }
    } catch (e) {
      // throw Exception('Error: $e');
      if (kDebugMode) {
        print('Failed to schedule meeting: final error is $e');
      }
      FlutterLogs.logError("scheduleMeeting", "UnknownCase", '$e');
      return null;
    }
  }

  /// 更新会议
  Future<Object?> editMeeting(EditOptions editOptions) async {
    try {
      // print("editOptions: ${editOptions}.toString()");
      // FlutterLogs.logInfo(
      //     'restapi', "setUpLogs", "setUpLogs: Setting up logs..");

      var response = await dio.post(
        '/v1/meeting/update',
        data: {
          'meeting_id': editOptions.meetingId,
          'id': editOptions.meetingNumb,
          'api_key': APP.apiKey,
          'api_secret': APP.apiSecret,
          'host_id': editOptions.hostId,
          'topic': editOptions.topic,
          'start_time': editOptions.startTime,
          'duration': editOptions.duration,
          'type': editOptions.type,
          'option_use_pmi': editOptions.optionUsePmi,
          // 使用个人会议号
          'password': editOptions.password,
          // 需要会议密码
          'option_host_video': editOptions.optionHostVideo,
          // 主持人视频开启
          'option_participants_video': editOptions.optionParticipantsVideo,
          // 参会者视频开启
          'option_jbh': editOptions.optionJbh,
          // 允许参会者随时加会
          'option_waiting_room': editOptions.optionWaitingRoom,
          // 启用等候室
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      Map<String, dynamic> responseData = response.data;
      if (response.statusCode == 200) {
        if (responseData.containsKey('error')) {
          if (kDebugMode) {
            print('[editMeeting] error: $responseData');
          }
          FlutterLogs.logError("editMeeting", "responseError", '$responseData');
          Map<String, dynamic> errorMap = responseData['error'];
          return errorMap;
        }
        return true;
      } else {
        // 处理请求失败的情况
        if (kDebugMode) {
          print('Failed to edit meeting, error occurs $responseData');
        }
        FlutterLogs.logError(
            "editMeeting", "responseStatusOtherThan200", '$responseData');
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to edit meeting: final error is $e');
      }
      FlutterLogs.logError("editMeeting", "UnknownCase", '$e');
      return null;
    }
  }
}
