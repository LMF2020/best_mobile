import 'dart:async';

import 'package:sparkmob/sdk/zoom_options.dart';
import 'package:sparkmob/sdk/zoom_view.dart';

export 'zoom_options.dart';

abstract class ZoomPlatform {
  static ZoomPlatform _instance = ZoomView();

  static ZoomPlatform get instance => _instance;

  static set instance(ZoomPlatform instance) {
    _instance = instance;
  }

  /// Flutter Zoom SDK Initialization function
  Future<List> initZoom(ZoomOptions options) async {
    throw UnimplementedError('initZoom() has not been implemented.');
  }

  /// Flutter Zoom SDK Initialization function
  Future<List> loginZoom(ZoomMeetingOptions options) async {
    throw UnimplementedError('loginZoom() has not been implemented.');
  }

  /// Flutter Zoom SDK Initialization function
  Future<bool> logoutZoom() async {
    throw UnimplementedError('logoutZoom() has not been implemented.');
  }

  /// Flutter Zoom SDK Initialization function
  Future<bool> isSdkInit() async {
    throw UnimplementedError('isSdkInit() has not been implemented.');
  }

  /// Flutter Zoom SDK Start Meeting function
  Future<List> startInstantMeeting(ZoomMeetingOptions options) async {
    throw UnimplementedError('startInstantMeeting() has not been implemented.');
  }

  /// Flutter Zoom SDK Start Meeting with Custom Meeting ID function
  Future<List> startMeetingWithNumber(ZoomMeetingOptions options) async {
    throw UnimplementedError('startMeetingNormal() has not been implemented.');
  }

  /// Flutter Zoom SDK Join Meeting function
  Future<bool> joinMeeting(ZoomMeetingOptions options) async {
    throw UnimplementedError('joinMeeting() has not been implemented.');
  }

  /// Flutter Zoom SDK Get Meeting Status function
  Future<List> meetingStatus(String meetingId) async {
    throw UnimplementedError('meetingStatus() has not been implemented.');
  }

  /// Flutter Zoom SDK Listen to Meeting Status function
  Stream<dynamic> onMeetingStatus() {
    throw UnimplementedError('onMeetingStatus() has not been implemented.');
  }

  /// Flutter Zoom SDK Get Meeting ID & Passcode after Starting Meeting function
  Future<List> meetingDetails() async {
    throw UnimplementedError('meetingDetails() has not been implemented.');
  }
}
