import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DeviceMonitoringDTO {
  @JsonKey(name: 'Device')
  String? device;
  @JsonKey(name: 'Version')
  String? version;
  @JsonKey(name: 'Product')
  String? product;
  @JsonKey(name: 'DeviceModel')
  String? model;
  @JsonKey(name: 'Brand')
  String? brand;
  @JsonKey(name: 'AndroidId')
  String? androidId;
  @JsonKey(name: 'SecureId')
  String? secureId;
  @JsonKey(name: 'SDK')
  String? sdk;
  @JsonKey(name: 'Width')
  double? width;
  @JsonKey(name: 'Height')
  double? height;
  @JsonKey(name: 'WidthLogical')
  double? widthLogical;
  @JsonKey(name: 'HeightLogical')
  double? heightLogical;
  @JsonKey(name: 'Username')
  String? username;
  @JsonKey(name: 'LastAttempt')
  String? loginAttempt;
  @JsonKey(name: 'BatteryLevel')
  int? batteryLevel;
  @JsonKey(name: 'Date')
  DateTime? date;

  DeviceMonitoringDTO(
      {this.device,
      this.version,
      this.product,
      this.model,
      this.brand,
      this.androidId,
      this.secureId,
      this.sdk,
      this.width,
      this.height,
      this.widthLogical,
      this.heightLogical,
      this.username,
      this.loginAttempt,
      this.batteryLevel,
      this.date});

  factory DeviceMonitoringDTO.fromMap(Map<String, dynamic> map) => _$DeviceMonitoringDTOFromJson(map);

  factory DeviceMonitoringDTO.fromJson(Map<String, dynamic> json) => _$DeviceMonitoringDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceMonitoringDTOToJson(this);

  static List<DeviceMonitoringDTO> fromList(List<Map<String, String>> list) => list.map(DeviceMonitoringDTO.fromMap).toList();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceMonitoringDTO _$DeviceMonitoringDTOFromJson(Map<String, dynamic> json) => DeviceMonitoringDTO(
      device: json['Device'] as String?,
      version: json['Version'] as String?,
      product: json['Product'] as String?,
      model: json['DeviceModel'] as String?,
      brand: json['Brand'] as String?,
      androidId: json['AndroidId'] as String?,
      secureId: json['SecureId'] as String?,
      sdk: json['SDK'] as String?,
      width: (json['Width'] as num?)?.toDouble(),
      height: (json['Height'] as num?)?.toDouble(),
      widthLogical: (json['WidthLogical'] as num?)?.toDouble(),
      heightLogical: (json['HeightLogical'] as num?)?.toDouble(),
      username: json['Username'] as String?,
      loginAttempt: DateFormat("yyyy-MM-dd hh:mm:ss").format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(json['LastAttempt'] as String)),
      batteryLevel: json['BatteryLevel'] as int?,
      date: DateTime.fromMillisecondsSinceEpoch(json['Date']),
    );

Map<String, dynamic> _$DeviceMonitoringDTOToJson(DeviceMonitoringDTO instance) => <String, dynamic>{
      'Device': instance.device,
      'Version': instance.version,
      'Product': instance.product,
      'DeviceModel': instance.model,
      'Brand': instance.brand,
      'AndroidId': instance.androidId,
      'SecureId': instance.secureId,
      'SDK': instance.sdk,
      'Width': instance.width,
      'Height': instance.height,
      'WidthLogical': instance.widthLogical,
      'HeightLogical': instance.heightLogical,
      'Username': instance.username,
      'LastAttempt': instance.loginAttempt,
      'BatteryLevel': instance.batteryLevel,
      'Date': instance.date,
    };
