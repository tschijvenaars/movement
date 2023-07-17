import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_batch_dto.dart';

import '../database/database.dart';
import '../dtos/google_place_dto.dart';
import '../dtos/parsed_response.dart';
import '../dtos/user_sensor_geolocation_data_dto.dart';
import 'base_api.dart';

class SensorGeoLocationApi extends BaseApi {
  SensorGeoLocationApi(Database database) : super("syncing/", database);

  Future<ParsedResponse<SensorGeolocationBatchDTO>> syncBatchGeoLocation(SensorGeolocationBatchDTO batch) async =>
      getParsedResponse<SensorGeolocationBatchDTO, SensorGeolocationBatchDTO>('SyncBatchGeolocation', SensorGeolocationBatchDTO.fromMap, payload: batch);
}
