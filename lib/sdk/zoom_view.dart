import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sparkmob/sdk/zoom_platform_view.dart';

class ZoomView extends ZoomPlatform {
  final MethodChannel channel = const MethodChannel('com.meetspark/spark_sdk');

  /// The event channel used to interact with the native platform.
  final EventChannel eventChannel =
      const EventChannel('com.meetspark/spark_sdk_event_stream');

  /// The event channel used to interact with the native platform init function
  @override
  Future<List> initZoom(ZoomOptions options) async {
    var optionMap = <String, String?>{};

    if (options.appKey != null) {
      optionMap.putIfAbsent("appKey", () => options.appKey!);
    }
    if (options.appSecret != null) {
      optionMap.putIfAbsent("appSecret", () => options.appSecret!);
    }
    if (options.jwtToken != null) {
      optionMap.putIfAbsent("jwtToken", () => options.jwtToken!);
    }
    if (options.locale != null) {
      optionMap.putIfAbsent("locale", () => options.locale);
    }
    optionMap.putIfAbsent("domain", () => options.domain);
    return await channel
        .invokeMethod<List>('init', optionMap)
        .then<List>((List? value) => value ?? List.empty());
  }

  @override
  Future<List> loginZoom(ZoomMeetingOptions options) async {
    var optionMap = <String, String?>{};
    optionMap.putIfAbsent("userId", () => options.userId);
    optionMap.putIfAbsent("userPassword", () => options.userPassword);
    return await channel
        .invokeMethod<List>('login', optionMap)
        .then<List>((List? value) => value ?? List.empty());
  }

  @override
  Future<bool> changeLanguage(ZoomMeetingOptions options) async {
    var optionMap = <String, String?>{};
    optionMap.putIfAbsent("locale", () => options.locale);
    return await channel
        .invokeMethod<bool>('changeLanguage', optionMap)
        .then<bool>((bool? value) => value ?? false);
  }

  @override
  Future<bool> leaveMeeting() async {
    return await channel
        .invokeMethod<bool>('changeLanguage')
        .then<bool>((bool? value) => value ?? false);
  }

  @override
  Future<bool> isSdkInit() async {
    return await channel
        .invokeMethod<bool>('isSdkInit')
        .then<bool>((bool? value) => value ?? false);
  }

  @override
  Future<bool> logoutZoom() async {
    return await channel
        .invokeMethod<bool>('logout')
        .then<bool>((bool? value) => value ?? false);
  }

  /// The event channel used to interact with the native platform startMeetingNormal function
  @override
  Future<List> startMeetingWithNumber(ZoomMeetingOptions options) async {
    var optionMap = <String, String?>{};
    optionMap.putIfAbsent("userId", () => options.userId);
    optionMap.putIfAbsent("userPassword", () => options.userPassword);
    optionMap.putIfAbsent("meetingId", () => options.meetingId);
    optionMap.putIfAbsent("disableDialIn", () => options.disableDialIn);
    optionMap.putIfAbsent("disableDrive", () => options.disableDrive);
    optionMap.putIfAbsent("disableInvite", () => options.disableInvite);
    optionMap.putIfAbsent("disableShare", () => options.disableShare);
    optionMap.putIfAbsent("disableTitlebar", () => options.disableTitlebar);
    optionMap.putIfAbsent("noDisconnectAudio", () => options.noDisconnectAudio);
    optionMap.putIfAbsent("noAudio", () => options.noAudio);
    optionMap.putIfAbsent("viewOptions", () => options.viewOptions);
    optionMap.putIfAbsent('zak', () => options.zoomAccessToken);
    optionMap.putIfAbsent('token', () => options.zoomToken);
    optionMap.putIfAbsent('displayName', () => options.displayName);

    return await channel
        .invokeMethod<List>('startMeetingWithNumber', optionMap)
        .then<List>((List? value) => value ?? List.empty());
  }

  /// The event channel used to interact with the native platform joinMeeting function
  @override
  Future<bool> joinMeeting(ZoomMeetingOptions options) async {
    var optionMap = <String, String?>{};
    optionMap.putIfAbsent("userId", () => options.userId);
    optionMap.putIfAbsent("meetingId", () => options.meetingId);
    optionMap.putIfAbsent("meetingPassword", () => options.meetingPassword);
    optionMap.putIfAbsent("disableDialIn", () => options.disableDialIn);
    optionMap.putIfAbsent("disableDrive", () => options.disableDrive);
    optionMap.putIfAbsent("disableInvite", () => options.disableInvite);
    optionMap.putIfAbsent("disableShare", () => options.disableShare);
    optionMap.putIfAbsent("disableTitlebar", () => options.disableTitlebar);
    optionMap.putIfAbsent("noDisconnectAudio", () => options.noDisconnectAudio);
    optionMap.putIfAbsent("viewOptions", () => options.viewOptions);
    optionMap.putIfAbsent("noAudio", () => options.noAudio);
    optionMap.putIfAbsent("enableVideo", () => options.enableVideo);

    return await channel
        .invokeMethod<bool>('joinMeeting', optionMap)
        .then<bool>((bool? value) => value ?? false);
  }

  /// The event channel used to interact with the native platform startMeeting(login on iOS & Android) function
  @override
  Future<List> startInstantMeeting(ZoomMeetingOptions options) async {
    var optionMap = <String, String?>{};
    optionMap.putIfAbsent("userId", () => options.userId);
    optionMap.putIfAbsent("userPassword", () => options.userPassword);
    optionMap.putIfAbsent("disableDialIn", () => options.disableDialIn);
    optionMap.putIfAbsent("disableDrive", () => options.disableDrive);
    optionMap.putIfAbsent("disableInvite", () => options.disableInvite);
    optionMap.putIfAbsent("disableShare", () => options.disableShare);
    optionMap.putIfAbsent("disableTitlebar", () => options.disableTitlebar);
    optionMap.putIfAbsent("viewOptions", () => options.viewOptions);
    optionMap.putIfAbsent("noDisconnectAudio", () => options.noDisconnectAudio);
    optionMap.putIfAbsent("noAudio", () => options.noAudio);
    optionMap.putIfAbsent("enableVideo", () => options.enableVideo);
    optionMap.putIfAbsent("pmi", () => options.pmi);
    optionMap.putIfAbsent('meetingId', () => options.meetingId);
    optionMap.putIfAbsent('zak', () => options.zoomAccessToken);
    optionMap.putIfAbsent('token', () => options.zoomToken);
    optionMap.putIfAbsent('displayName', () => options.displayName);

    return await channel
        .invokeMethod<List>('startInstantMeeting', optionMap)
        .then<List>((List? value) => value ?? List.empty());
  }

  /// The event channel used to interact with the native platform meetingStatus function
  @override
  Future<List> meetingStatus(String meetingId) async {
    var optionMap = <String, String>{};
    optionMap.putIfAbsent("meetingId", () => meetingId);

    return await channel
        .invokeMethod<List>('meeting_status', optionMap)
        .then<List>((List? value) => value ?? List.empty());
  }

  /// The event channel used to interact with the native platform onMeetingStatus(iOS & Android) function
  @override
  Stream<dynamic> onMeetingStatus() {
    return eventChannel.receiveBroadcastStream();
  }

  /// The event channel used to interact with the native platform meetinDetails(iOS & Android) function
  @override
  Future<List> meetingDetails() async {
    return await channel
        .invokeMethod<List>('meeting_details')
        .then<List>((List? value) => value ?? List.empty());
  }
}
