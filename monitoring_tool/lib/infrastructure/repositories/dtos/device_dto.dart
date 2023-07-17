import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DeviceDTO {
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

  DeviceDTO(
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
      this.heightLogical});

  factory DeviceDTO.fromMap(Map<String, dynamic> map) =>
      _$DeviceDTOFromJson(map);

  factory DeviceDTO.fromJson(Map<String, dynamic> json) =>
      _$DeviceDTOFromJson(json);

  factory DeviceDTO.fromDevice(Device device) => DeviceDTO(
      device: device.device,
      version: device.version,
      product: device.product,
      model: device.model,
      brand: device.brand,
      androidId: device.androidId,
      secureId: device.secureId,
      sdk: device.sdk,
      width: device.width,
      height: device.height,
      widthLogical: device.widthLogical,
      heightLogical: device.heightLogical);

  Map<String, dynamic> toJson() => _$DeviceDTOToJson(this);

  static List<DeviceDTO> fromList(List<Map<String, String>> list) =>
      list.map(DeviceDTO.fromMap).toList();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDTO _$DeviceDTOFromJson(Map<String, dynamic> json) => DeviceDTO(
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
    );

Map<String, dynamic> _$DeviceDTOToJson(DeviceDTO instance) => <String, dynamic>{
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
    };

class Device {
  final int? id;
  final String? device;
  final String? version;
  final String? product;
  final String? model;
  final String? brand;
  final String? androidId;
  final String? secureId;
  final String? sdk;
  final double? width;
  final double? height;
  final double? widthLogical;
  final double? heightLogical;
  Device(
      {this.id,
      this.device,
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
      this.heightLogical});
}
