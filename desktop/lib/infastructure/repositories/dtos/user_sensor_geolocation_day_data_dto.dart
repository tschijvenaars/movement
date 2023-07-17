import 'package:desktop/infastructure/repositories/database/database.dart';
import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';
import 'package:desktop/infastructure/repositories/dtos/tracked_day_dto.dart';

import 'location_dto.dart';

class UserSensorGeolocationDayDataDTO {
  List<SensorGeolocationDTO> rawdata;
  List<List<SensorGeolocationDTO>> testRawdata;
  TrackedDayDTO trackedDay;

  UserSensorGeolocationDayDataDTO({required this.rawdata, required this.testRawdata, required this.trackedDay});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["RawData"] = rawdata;
    data["ValidatedData"] = rawdata;

    return data;
  }

  factory UserSensorGeolocationDayDataDTO.fromMap(Map<String, dynamic> json) => UserSensorGeolocationDayDataDTO(
      rawdata: json["RawData"] == null ? [] : SensorGeolocationDTO.fromList(json["RawData"]),
      testRawdata: json["TestRawData"] == null ? [] : SensorGeolocationDTO.fromListList(json["TestRawData"]),
      trackedDay: TrackedDayDTO.fromMap(json["ValidatedData"]));

  static List<UserSensorGeolocationDayDataDTO> fromList(List<dynamic> list) {
    List<UserSensorGeolocationDayDataDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(UserSensorGeolocationDayDataDTO.fromMap(item));
    }

    return mappedList;
  }
}
