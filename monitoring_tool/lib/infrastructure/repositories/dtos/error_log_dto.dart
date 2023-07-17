import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ErrorLogDTO {
  int? DeviceID;
  String? Type;
  int? dateTime;
  String? message;
  String? typeException;
  String? CreatedAt;

  ErrorLogDTO({this.DeviceID, this.Type, this.dateTime, this.message, this.typeException, this.CreatedAt});

  factory ErrorLogDTO.fromMap(Map<String, dynamic> map) => _$ErrorLogDTOFromJson(map);

  Map<String, dynamic> toMap() => _$ErrorLogDTOToJson(this);

  static List<ErrorLogDTO> fromList(List<Map<String, String>> list) => list.map(ErrorLogDTO.fromMap).toList();
}

ErrorLogDTO _$ErrorLogDTOFromJson(Map<String, dynamic> json) => ErrorLogDTO(
      DeviceID: json['DeviceID'] as int?,
      Type: json['Type'] as String?,
      dateTime: json['dateTime'] as int?,
      message: json['message'] as String?,
      typeException: json['typeException'] as String?,
      CreatedAt: json['CreatedAt'] as String?,
    );

Map<String, dynamic> _$ErrorLogDTOToJson(ErrorLogDTO instance) => <String, dynamic>{
      'DeviceID': instance.DeviceID,
      'Type': instance.Type,
      'dateTime': instance.dateTime,
      'message': instance.message,
      'typeException': instance.typeException,
      'CreatedAt': instance.CreatedAt,
    };
