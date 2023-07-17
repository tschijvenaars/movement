import 'package:flutter/material.dart';

import '../../presentation/widgets/elements/kpi_label_combi.dart';
import '../repositories/network/devices_api.dart';

class UserDeviceKpiNotifier extends ChangeNotifier {
  List<Widget> kpiLabels = [];

  final MonitoringApi _monitoringApi;
  UserDeviceKpiNotifier(this._monitoringApi);

  MonitoringApi get monitoringApi => _monitoringApi;

  /// Gets KPI stats DTO from monitoringAPI and fills in a List of KPI labels to display
  Future<void> getUserKpis() async {
    final kpis = await _monitoringApi.getKpiStats();
    final payload = kpis.payload!;
    kpiLabels = [];
    kpiLabels.add(KpiLabel(payload.UserTotalName, payload.UserTotal.toString()));
    kpiLabels.add(KpiLabel(payload.UserUnusedName, payload.UserUnused.toString()));
    kpiLabels.add(KpiLabel(payload.TotalLocationsName, payload.TotalLocations.toString()));
    kpiLabels.add(KpiLabel(payload.TotalLocationsDayName, payload.TotalLocationsDay.toString()));
    notifyListeners();
  }
}
