import 'dart:async';
import 'package:flutter/material.dart';

import 'DeviceSnapshot.dart';
import 'PulseToastWidget.dart';


class DevicePulse with WidgetsBindingObserver {
  DevicePulse._();
  static final DevicePulse instance = DevicePulse._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Timer? _timer;
  OverlayEntry? _currentEntry;
  bool _isAllowed = false;
  Duration _interval = const Duration(minutes: 2);

  /// User jab "Allow All" par click kare tab isko call karein
  void grantPermissionAndStart({Duration interval = const Duration(minutes: 2)}) {
    _isAllowed = true;
    _interval = interval;
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
    triggerNow(); // Turant pehla toast dikhane ke liye
  }

  /// Stop karne ke liye
  void stop() {
    _isAllowed = false;
    _timer?.cancel();
    _removeOverlay();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _startTimer() {
    _timer?.cancel();
    if (!_isAllowed) return;
    _timer = Timer.periodic(_interval, (_) => triggerNow());
  }

  /// App foreground/background state handle karne ke liye
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isAllowed) return;
    if (state == AppLifecycleState.resumed) {
      _startTimer();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _timer?.cancel();
    }
  }

  Future<void> triggerNow() async {
    final overlayState = navigatorKey.currentState?.overlay;
    if (overlayState == null) return;

    final snapshot = await DeviceInfoService.getSnapshot();
    _removeOverlay();

    _currentEntry = OverlayEntry(
      builder: (_) => PulseToastWidget(
        snapshot: snapshot,
        onDismiss: _removeOverlay,
      ),
    );

    overlayState.insert(_currentEntry!);

    // 6 second baad automatically toast hide ho jayega
    Future.delayed(const Duration(seconds: 6), _removeOverlay);
  }

  void _removeOverlay() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}