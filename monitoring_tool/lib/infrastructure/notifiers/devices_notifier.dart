import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoring_tool/infrastructure/repositories/dtos/sync_dto.dart';

import '../repositories/dtos/device_monitoring_dto.dart';
import '../repositories/network/devices_api.dart';
import 'generic_statenotifier.dart';

class DevicesNotifier extends StateNotifier<NotifierState> {
  final MonitoringApi _monitoringApi;
  //late List<DeviceMonitoringDTO> dataList;

  DevicesNotifier(this._monitoringApi) : super(const Initial());

  /// Gets devices from monitoring API call and assigns devices
  Future<void> getDevices() async {
    state = const Loading();
    final devices = await _monitoringApi.getSyncs();
    state = Loaded<List<SyncDTO>>(devices.payload!);
  }

  Future<void> deleteTrackedDays(int userId) async {
    state = const Loading();
    final device = await _monitoringApi.deleteTrackedDays(userId);
    final devices = await _monitoringApi.getSyncs();
    state = Loaded<List<SyncDTO>>(devices.payload!);
  }

  // void changeStatusMetric(String metric) {
  //   switch (metric) {
  //     case 'hour':

  //       break;
  //     case 'day':
  //       break;
  //   }
  // }

  Color drawStatusColor(DateTime date, DateTime now) {
    try {
      final tenMinutesMark = now.subtract(const Duration(minutes: 10));
      final hoursMark = now.subtract(const Duration(hours: 1));
      final dayMark = now.subtract(const Duration(days: 1));
      if (date.isAfter(tenMinutesMark)) {
        return Colors.green;
      } else if (date.isAfter(hoursMark)) {
        return Colors.yellow;
      } else if (date.isAfter(dayMark)) {
        return Colors.orange;
      } else if (date.isAfter(DateTime(2001))) {
        return Colors.red;
      } else {
        return Colors.black;
      }
    } catch (e) {
      return Colors.black;
    }
  }
}
