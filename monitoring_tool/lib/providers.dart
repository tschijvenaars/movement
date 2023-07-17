import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:monitoring_tool/infrastructure/notifiers/devices_notifier.dart';
import 'package:monitoring_tool/infrastructure/notifiers/logs_notifier.dart';
import 'package:monitoring_tool/infrastructure/repositories/network/devices_api.dart';

import 'infrastructure/notifiers/app_navigation_notifier.dart';
import 'infrastructure/notifiers/generic_statenotifier.dart';
import 'infrastructure/notifiers/settings_notifier.dart';
import 'infrastructure/notifiers/signup_notifier.dart';
import 'infrastructure/notifiers/user_device_kpi_notifier.dart';
import 'infrastructure/repositories/network/auth_api.dart';

final appNavigationNotifier = ChangeNotifierProvider(
  (ref) => AppNavigationNotifier(),
);

final settingsNotifier = ChangeNotifierProvider(
  (ref) => SettingsNotifier(ref.watch(authApi)),
);

final signupNotifier = ChangeNotifierProvider((ref) => SignupNotifier(ref.watch(authApi)));

final secureStorage = Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

final authApi = Provider<AuthApi>((ref) => AuthApi(ref.watch(secureStorage)));
final monitoringApi = Provider<MonitoringApi>((ref) => MonitoringApi(ref.watch(secureStorage)));

final devicesNotifierProvider = StateNotifierProvider<DevicesNotifier, NotifierState>(
  (ref) => DevicesNotifier(ref.watch(monitoringApi)),
);

final logsNotifierProvider = StateNotifierProvider<LogsNotifier, NotifierState>(
  (ref) => LogsNotifier(ref.watch(monitoringApi)),
);

final userDeviceKpiNotifier = ChangeNotifierProvider(
  (ref) => UserDeviceKpiNotifier(ref.watch(monitoringApi)),
);
