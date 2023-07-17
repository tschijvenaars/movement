import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart' as json;

import 'device_dto.dart';

@json.JsonSerializable()
class LogDTO {
  @json.JsonKey(name: 'Message')
  String? message;
  @json.JsonKey(name: 'Description')
  String? description;
  @json.JsonKey(name: 'Type')
  String? type;
  @json.JsonKey(name: 'DateTime')
  int datetime;
  @json.JsonKey(name: 'Device')
  DeviceDTO deviceDTO;

  LogDTO({
    required this.message,
    required this.description,
    required this.deviceDTO,
    required this.type,
    required this.datetime,
  });

  factory LogDTO.fromMap(Map<String, dynamic> map) => _$LogDTOFromJson(map);

  factory LogDTO.fromLog(Log log, DeviceDTO deviceDTO) => LogDTO(
        message: log.message,
        description: log.description,
        type: log.type,
        datetime: log.date!.microsecondsSinceEpoch,
        deviceDTO: deviceDTO,
      );

  Map<String, dynamic> toJson() => _$LogDTOToJson(this);

  static List<LogDTO> fromList(List<Log> list, DeviceDTO deviceDTO) {
    return list.map((log) => LogDTO.fromLog(log, deviceDTO)).toList();
  }

  static List<Map<String, dynamic>> toList(List<LogDTO> list) {
    return list.map((log) => log.toJson()).toList();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogDTO _$LogDTOFromJson(Map<String, dynamic> json) => LogDTO(
      message: json['Message'] as String?,
      description: json['Description'] as String?,
      deviceDTO: DeviceDTO.fromJson(json['Device'] as Map<String, dynamic>),
      type: json['Type'] as String?,
      datetime: json['DateTime'] as int,
    );

Map<String, dynamic> _$LogDTOToJson(LogDTO instance) => <String, dynamic>{
      'Message': instance.message,
      'Description': instance.description,
      'Type': instance.type,
      'DateTime': instance.datetime,
      'Device': instance.deviceDTO.toJson(),
    };

class Log extends DataClass implements Insertable<Log> {
  final int? id;
  final String? message;
  final String? description;
  final String? type;
  final DateTime? date;
  final bool? synced;
  Log({this.id, this.message, this.description, this.type, this.date, this.synced});
  factory Log.fromData(Map<String, dynamic> data, GeneratedDatabase db, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Log(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      message: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}message']),
      description: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}description']),
      type: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}type']),
      date: const DateTimeType().mapFromDatabaseResponse(data['${effectivePrefix}date']),
      synced: const BoolType().mapFromDatabaseResponse(data['${effectivePrefix}synced']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int?>(id);
    }
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String?>(message);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String?>(description);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String?>(type);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime?>(date);
    }
    if (!nullToAbsent || synced != null) {
      map['synced'] = Variable<bool?>(synced);
    }
    return map;
  }

  Log copyWith({int? id, String? message, String? description, String? type, DateTime? date, bool? synced}) => Log(
        id: id ?? this.id,
        message: message ?? this.message,
        description: description ?? this.description,
        type: type ?? this.type,
        date: date ?? this.date,
        synced: synced ?? this.synced,
      );

  @override
  String toString() {
    return (StringBuffer('Log(')
          ..write('id: $id, ')
          ..write('message: $message, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, message, description, type, date, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Log &&
          other.id == this.id &&
          other.message == this.message &&
          other.description == this.description &&
          other.type == this.type &&
          other.date == this.date &&
          other.synced == this.synced);

  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
