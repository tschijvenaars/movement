import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LocationDTO {
  final double lon;
  final double lat;
  final double altitude;
  final double accuracy;
  final double speed;
  final int date;
  final double? bearing;
  final String? sensorType;
  final String? provider;

  LocationDTO({
    required this.lon,
    required this.lat,
    required this.altitude,
    required this.accuracy,
    required this.speed,
    required this.date,
    this.bearing,
    this.sensorType,
    this.provider,
  });

  Map<String, dynamic> toMap() => _$LocationDTOToJson(this);

  factory LocationDTO.fromJson(String json) =>
      _$LocationDTOFromJson(jsonDecode(json) as Map<String, dynamic>);

  factory LocationDTO.fromMap(Map<String, dynamic> map) =>
      _$LocationDTOFromJson(map);

  static List<LocationDTO> fromList(List<Map<String, dynamic>> list) =>
      list.map(LocationDTO.fromMap).toList();

  Map<String, dynamic> toJson() => _$LocationDTOToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationDTO _$LocationDTOFromJson(Map<String, dynamic> json) => LocationDTO(
      lon: (json['lon'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      date: json['date'] as int,
      bearing: (json['bearing'] as num?)?.toDouble(),
      sensorType: json['sensorType'] as String?,
      provider: json['provider'] as String?,
    );

Map<String, dynamic> _$LocationDTOToJson(LocationDTO instance) =>
    <String, dynamic>{
      'lon': instance.lon,
      'lat': instance.lat,
      'altitude': instance.altitude,
      'accuracy': instance.accuracy,
      'speed': instance.speed,
      'date': instance.date,
      'bearing': instance.bearing,
      'sensorType': instance.sensorType,
      'provider': instance.provider,
    };
