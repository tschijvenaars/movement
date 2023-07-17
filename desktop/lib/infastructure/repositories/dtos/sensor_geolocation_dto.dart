import 'package:desktop/infastructure/repositories/database/database.dart';

class SensorGeolocationDTO {
  double lon, lat, altitude, speed, bearing, accuracy, calculatedSpeed, density;
  int createdOn, batteryLevel;
  int? deletedOn;
  String sensorType;

  SensorGeolocationDTO(
      {required this.lon,
      required this.lat,
      required this.altitude,
      required this.sensorType,
      required this.speed,
      required this.bearing,
      required this.accuracy,
      required this.batteryLevel,
      required this.createdOn,
      required this.deletedOn,
      required this.calculatedSpeed,
      required this.density});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = lat;
    data['longitude'] = lon;
    data['altitude'] = altitude;
    data['accuracy'] = accuracy;
    data['sensorType'] = sensorType;
    data['createdOn'] = createdOn;
    data['deletedOn'] = deletedOn;
    data['bearing'] = bearing;
    data['speed'] = speed;
    data['batteryLevel'] = batteryLevel;

    return data;
  }

  factory SensorGeolocationDTO.fromMap(Map<String, dynamic> json) => SensorGeolocationDTO(
      lat: json["latitude"],
      lon: json["longitude"],
      altitude: double.parse(json["altitude"].toString()),
      sensorType: json["sensorType"],
      createdOn: json["createdOn"],
      deletedOn: json["deletedOn"],
      bearing: json["bearing"] / 1.0,
      speed: (json["speed"]) / 1.0,
      batteryLevel: json["batteryLevel"],
      accuracy: json["accuracy"] / 1.0,
      calculatedSpeed: 0,
      density: 0.0);

  static List<SensorGeolocationDTO> fromList(List<dynamic> list) {
    List<SensorGeolocationDTO> mappedList = [];
    for (var item in list) {
      mappedList.add(SensorGeolocationDTO.fromMap(item));
    }

    return mappedList;
  }

  static List<List<SensorGeolocationDTO>> fromListList(List<dynamic> list) {
    List<List<SensorGeolocationDTO>> mappedList = [];
    for (var item in list) {
      List<SensorGeolocationDTO> locationList = [];
      for (var j in item) {
        locationList.add(SensorGeolocationDTO.fromMap(j));
      }
      mappedList.add(locationList);
    }

    return mappedList;
  }
}
