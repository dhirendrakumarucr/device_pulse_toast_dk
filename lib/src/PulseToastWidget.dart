import 'package:flutter/material.dart';
import 'DeviceSnapshot.dart';

class PulseToastWidget extends StatelessWidget {
  final DeviceSnapshot snapshot;
  final VoidCallback onDismiss;

  const PulseToastWidget({
    super.key,
    required this.snapshot,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Tablet/Desktop par max 450px width, mobile par 92% width
    final cardWidth = screenWidth > 500 ? 450.0 : screenWidth * 0.92;

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: cardWidth,
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1E2C), Color(0xFF2D2B55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.4), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.radar, color: Colors.cyanAccent, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'LIVE DEVICE TELEMETRY',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onDismiss,
                      child: const Icon(Icons.close, color: Colors.white70, size: 18),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildChip(Icons.phone_android, 'Brand', snapshot.brand, Colors.amberAccent),
                    _buildChip(Icons.wifi, 'IP', snapshot.ipAddress, Colors.greenAccent),
                    _buildChip(Icons.storage, 'Storage', snapshot.storageInfo, Colors.pinkAccent),
                    _buildChip(Icons.fingerprint, 'ID', snapshot.deviceId, Colors.lightBlueAccent),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label, String value, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              '$label: $value',
              style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}