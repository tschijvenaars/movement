import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class KpiDTO {
  int UserTotal;
  int UserUnused;
  int TotalLocationsDay;
  int TotalLocations;
  String UserTotalName = 'Total Users';
  String UserUnusedName = 'Usernames Unused';
  String TotalLocationsDayName = 'Total Locations per Day';
  String TotalLocationsName = 'Total Locations';

  KpiDTO(this.UserTotal, this.UserUnused, this.TotalLocationsDay, this.TotalLocations);

  factory KpiDTO.fromMap(Map<String, dynamic> map) => _$KpiStatsFromJson(map);

  Map<String, dynamic> toMap() => _$KpiStatsToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KpiDTO _$KpiStatsFromJson(Map<String, dynamic> json) => KpiDTO(
      json['UserTotal'] as int,
      json['UserUnused'] as int,
      json['TotalLocationsDay'] as int,
      json['TotalLocations'] as int,
    );

Map<String, dynamic> _$KpiStatsToJson(KpiDTO instance) => <String, dynamic>{
      'UserTotal': instance.UserTotal,
      'UserUnused': instance.UserUnused,
      'TotalLocationsDay': instance.TotalLocationsDay,
      'TotalLocations': instance.TotalLocations,
    };
