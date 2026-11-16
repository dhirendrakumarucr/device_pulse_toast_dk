# device_pulse_toast_dk

A responsive global overlay toast package for Flutter that periodically displays live device diagnostics (Brand, Device ID, Local IPv4 Address, and Storage) across any active screen.

## Platform Setup

### Android
Add INTERNET, ACCESS_NETWORK_STATE, and ACCESS_WIFI_STATE permissions to AndroidManifest.xml.

### iOS
Add NSLocalNetworkUsageDescription to Info.plist.

## Usage

1. Pass DevicePulse.instance.navigatorKey to MaterialApp.
2. Call DevicePulse.instance.grantPermissionAndStart(interval: Duration(minutes: 2)).
3. Call DevicePulse.instance.stop() to stop.
