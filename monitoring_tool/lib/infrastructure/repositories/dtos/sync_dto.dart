import 'package:json_annotation/json_annotation.dart';

part 'sync_dto.g.dart';

@JsonSerializable()
class SyncDTO {
  String device;
  int userId, batteryLevel, lastSync;
  List<int> lastSyncs, days;

  SyncDTO({required this.lastSync, required this.device, required this.userId, required this.batteryLevel, required this.lastSyncs, required this.days});

  factory SyncDTO.fromMap(Map<String, dynamic> map) => _$SyncDTOFromJson(map);

  factory SyncDTO.fromJson(Map<String, dynamic> json) => _$SyncDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SyncDTOToJson(this);

  static List<SyncDTO> fromList(List<Map<String, String>> list) => list.map(SyncDTO.fromMap).toList();
}
