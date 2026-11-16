import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceSnapshot {
  final String brand;
  final String deviceId;
  final String ipAddress;
  final String storageInfo;

  DeviceSnapshot({
    required this.brand,
    required this.deviceId,
    required this.ipAddress,
    required this.storageInfo,
  });
}

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<DeviceSnapshot> getSnapshot() async {
    String brand = 'Unknown';
    String deviceId = 'N/A';

    // 1. Company Name & Device ID
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        final android = await _deviceInfo.androidInfo;
        brand = '${android.manufacturer.toUpperCase()} (${android.model})';
        deviceId = android.id;
      } else if (Platform.isIOS) {
        final ios = await _deviceInfo.iosInfo;
        brand = 'Apple (${ios.utsname.machine})';
        deviceId = ios.identifierForVendor ?? 'Unknown-iOS';
      }
    }

    // 2. Local IP Address (Pure Dart)
    String ip = 'Offline / No IP';
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      if (interfaces.isNotEmpty && interfaces.first.addresses.isNotEmpty) {
        ip = interfaces.first.addresses.first.address;
      }
    } catch (_) {}

    // 3. Storage Info (Free / Total in GB)
    String storage = 'N/A';
    try {
      final diskSpace = DiskSpacePlus();
      final free = await diskSpace.getFreeDiskSpace ?? 0;
      final total = await diskSpace.getTotalDiskSpace ?? 0;
      storage = '${(free / 1024).toStringAsFixed(1)} GB free / ${(total / 1024).toStringAsFixed(1)} GB';
    } catch (_) {}

    return DeviceSnapshot(
      brand: brand,
      deviceId: deviceId,
      ipAddress: ip,
      storageInfo: storage,
    );
  }
}