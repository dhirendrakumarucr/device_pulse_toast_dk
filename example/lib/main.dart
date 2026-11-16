import 'package:flutter/material.dart';
import 'package:device_pulse_toast_dk/device_pulse_toast_dk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Device Pulse Toast Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
      ),
      // Required: Allows the telemetry toast to appear above every screen
      navigatorKey: DevicePulse.instance.navigatorKey,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMonitoring = false;

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.radar, color: Color(0xFF4F46E5), size: 36),
        title: const Text('Enable Live Diagnostics?'),
        content: const Text(
          'Allow the app to periodically display real-time device metrics '
              '(Brand, Device ID, Local IP, and Storage) across all active screens.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Deny'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _isMonitoring = true);
              // Set to 10 seconds for quick testing (use Duration(minutes: 2) in production)
              DevicePulse.instance.grantPermissionAndStart(
                interval: const Duration(seconds: 10),
              );
            },
            child: const Text('Allow All'),
          ),
        ],
      ),
    );
  }

  void _stopMonitoring() {
    DevicePulse.instance.stop();
    setState(() => _isMonitoring = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Pulse Telemetry'),
        centerTitle: true,
        backgroundColor: colors.primaryContainer,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isMonitoring ? Icons.sensors : Icons.sensors_off,
                      size: 56,
                      color: _isMonitoring ? Colors.green : colors.outline,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isMonitoring
                          ? 'Telemetry Active'
                          : 'Telemetry Inactive',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isMonitoring
                          ? 'A diagnostic overlay will appear automatically while the app is running.'
                          : 'Grant permission to monitor live device metrics across any screen.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Allow All & Start'),
                        onPressed: _isMonitoring ? null : _showPermissionDialog,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.layers_outlined),
                        label: const Text('Navigate to Second Screen'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SecondScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_isMonitoring) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          icon: const Icon(Icons.stop_circle_outlined,
                              color: Colors.red),
                          label: const Text(
                            'Stop Monitoring',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: _stopMonitoring,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      appBar: AppBar(
        title: const Text('Secondary Route'),
        centerTitle: true,
        backgroundColor: colors.secondaryContainer,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.picture_in_picture_alt,
                  size: 64, color: colors.primary),
              const SizedBox(height: 16),
              Text(
                'Global Overlay Test',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Even when you navigate deep into your app, the diagnostic toast remains active on top of every screen.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}