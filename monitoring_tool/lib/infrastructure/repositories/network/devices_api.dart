import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:monitoring_tool/infrastructure/repositories/dtos/device_dto.dart';
import 'package:monitoring_tool/infrastructure/repositories/dtos/error_log_dto.dart';
import 'package:monitoring_tool/infrastructure/repositories/dtos/googlemaps_error_dto.dart';
import 'package:monitoring_tool/infrastructure/repositories/dtos/log_dto.dart';
import 'package:monitoring_tool/infrastructure/repositories/dtos/sync_dto.dart';
import 'package:monitoring_tool/infrastructure/repositories/dtos/user_dto.dart';

import '../dtos/device_monitoring_dto.dart';
import '../dtos/kpi_dto.dart';
import '../dtos/parsed_response.dart';
import 'base_api.dart';

class MonitoringApi extends BaseApi {
  MonitoringApi(FlutterSecureStorage storage) : super('', storage);

  Future<ParsedResponse<List<SyncDTO>>> getSyncs() async {
    return getParsedResponse<List<SyncDTO>, SyncDTO>('syncMonitoring', SyncDTO.fromMap);
  }

  Future<ParsedResponse<DeviceDTO>> deleteTrackedDays(int userId) async {
    return getParsedResponse<DeviceDTO, DeviceDTO>('deleteTrackedDays/$userId', DeviceDTO.fromMap);
  }

  Future<ParsedResponse<List<DeviceMonitoringDTO>>> getDevices() async {
    return getParsedResponse<List<DeviceMonitoringDTO>, DeviceMonitoringDTO>('devicesMonitoring', DeviceMonitoringDTO.fromMap);
  }

  Future<ParsedResponse<List<LogDTO>>> getLogs() async {
    return getParsedResponse<List<LogDTO>, LogDTO>('logsMonitoring', LogDTO.fromMap);
  }

  Future<ParsedResponse<List<ErrorLogDTO>>> getErrorLogs() async {
    return getParsedResponse<List<ErrorLogDTO>, ErrorLogDTO>('errorMonitoring', ErrorLogDTO.fromMap);
  }

  Future<ParsedResponse<List<GoogleMapsErrorDTO>>> getGoogleErrorLogs() async {
    return getParsedResponse<List<GoogleMapsErrorDTO>, GoogleMapsErrorDTO>('googleErrorMonitoring', GoogleMapsErrorDTO.fromMap);
  }

  Future<ParsedResponse<List<UserDTO>>> getUnusedUsernames() {
    return getParsedResponse<List<UserDTO>, UserDTO>('unusedUsernames', UserDTO.fromMap);
  }

  Future<ParsedResponse<KpiDTO>> getKpiStats() {
    return getParsedResponse<KpiDTO, KpiDTO>('getKPIs', KpiDTO.fromMap);
  }
}
