class DeviceInfo {
  final String? deviceId;
  final String? deviceOS;

  DeviceInfo({
    this.deviceId,
    this.deviceOS,
  });

  /// load deviceInfo from http api
  factory DeviceInfo.fromMap(Map<String, dynamic> map) {
    return DeviceInfo(
      deviceId: map['device_id'],
      deviceOS: map['device_os'],
    );
  }

  @override
  String toString() {
    return 'DeviceInfo{deviceId: $deviceId, deviceOS: $deviceOS}';
  }
}
