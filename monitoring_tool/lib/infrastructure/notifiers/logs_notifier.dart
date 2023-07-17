import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/network/devices_api.dart';
import 'generic_statenotifier.dart';

class LogsNotifier extends StateNotifier<NotifierState> {
  final MonitoringApi _monitoringApi;
  LogsNotifier(this._monitoringApi) : super(const Initial());

  /// Gets a map of userlogs, errorlogs and google-errorlolgs from the monitoring API.
  Future<void> getAllLogs() async {
    Map<String, List<dynamic>> logsList = new Map<String, List<dynamic>>();
    state = const Loading();
    final logs = await _monitoringApi.getLogs();
    final errorLogs = await _monitoringApi.getErrorLogs();
    final googleLogs = await _monitoringApi.getGoogleErrorLogs();
    logsList['UserLogs'] = logs.payload!;
    logsList['ErrorLogs'] = errorLogs.payload!;
    logsList['GoogleLogs'] = googleLogs.payload!;
    state = Loaded<Map<String, List<dynamic>>>(logsList);
  }
}
