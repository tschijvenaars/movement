import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class GoogleMapsErrorDTO {
  int? UserId;
  String? ErrorMsg;
  String? CreatedAt;

  GoogleMapsErrorDTO({
    this.UserId,
    this.ErrorMsg,
    this.CreatedAt,
  });

  factory GoogleMapsErrorDTO.fromMap(Map<String, dynamic> map) => _$GoogleMapsErrorDTOFromJson(map);

  Map<String, dynamic> toMap() => _$GoogleMapsErrorDTOToJson(this);

  static List<GoogleMapsErrorDTO> fromList(List<Map<String, String>> list) => list.map(GoogleMapsErrorDTO.fromMap).toList();
}

GoogleMapsErrorDTO _$GoogleMapsErrorDTOFromJson(Map<String, dynamic> json) => GoogleMapsErrorDTO(
      CreatedAt: json['CreatedAt'] as String?,
      UserId: json['UserId'] as int?,
      ErrorMsg: json['ErrorMsg'] as String?,
    );

Map<String, dynamic> _$GoogleMapsErrorDTOToJson(GoogleMapsErrorDTO instance) => <String, dynamic>{
      'CreatedAt': instance.CreatedAt,
      'UserId': instance.UserId,
      'ErrorMsg': instance.ErrorMsg,
    };
