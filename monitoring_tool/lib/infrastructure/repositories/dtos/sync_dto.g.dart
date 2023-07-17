// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncDTO _$SyncDTOFromJson(Map<String, dynamic> json) => SyncDTO(
      lastSync: json['lastSync'] as int,
      device: json['device'] as String,
      userId: json['userId'] as int,
      batteryLevel: json['batteryLevel'] as int,
      lastSyncs: json['lastSyncs'] != null ? (json['lastSyncs'] as List<dynamic>).map((e) => e as int).toList() : [],
      days: json['days'] != null ? (json['days'] as List<dynamic>).map((e) => e as int).toList() : [0, 0, 0, 0, 0, 0, 0, 0],
    );

Map<String, dynamic> _$SyncDTOToJson(SyncDTO instance) => <String, dynamic>{
      'device': instance.device,
      'userId': instance.userId,
      'batteryLevel': instance.batteryLevel,
      'lastSync': instance.lastSync,
      'lastSyncs': instance.lastSyncs,
      'days': instance.days,
    };
