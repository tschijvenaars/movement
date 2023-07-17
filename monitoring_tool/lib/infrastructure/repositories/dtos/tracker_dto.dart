import 'package:json_annotation/json_annotation.dart';

import 'device_dto.dart';
import 'location_dto.dart';

@JsonSerializable()
class TrackerDTO {
  final int batteryLevel;
  final int date;
  final String sensorType; //TODO: should be an enum
  final List<LocationDTO>? locations;
  final DeviceDTO? device;

  TrackerDTO(
    this.batteryLevel,
    this.date,
    this.sensorType,
    this.locations,
    this.device,
  );

  Map<String, dynamic> toMap() => _$TrackerDTOToJson(this);

  factory TrackerDTO.fromMap(Map<String, dynamic> map) =>
      _$TrackerDTOFromJson(map);

  List<Map<String, dynamic>> locationsToMap(List<LocationDTO> locationListDTO) {
    return locationListDTO.map((locationDTO) => locationDTO.toMap()).toList();
  }

  static List<TrackerDTO> fromList(List<Map<String, dynamic>> list) {
    return list.map(TrackerDTO.fromMap).toList();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackerDTO _$TrackerDTOFromJson(Map<String, dynamic> json) => TrackerDTO(
      json['batteryLevel'] as int,
      json['date'] as int,
      json['sensorType'] as String,
      (json['locations'] as List<dynamic>?)
          ?.map((e) => LocationDTO.fromJson(e as String))
          .toList(),
      json['device'] == null
          ? null
          : DeviceDTO.fromJson(json['device'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrackerDTOToJson(TrackerDTO instance) =>
    <String, dynamic>{
      'batteryLevel': instance.batteryLevel,
      'date': instance.date,
      'sensorType': instance.sensorType,
      'locations': instance.locations?.map((e) => e.toJson()).toList(),
      'device': instance.device?.toJson(),
    };
