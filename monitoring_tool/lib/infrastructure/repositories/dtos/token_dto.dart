import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TokenDTO {
  final String token;

  TokenDTO(this.token);

  factory TokenDTO.fromMap(Map<String, dynamic> map) => _$TokenDTOFromJson(map);

  Map<String, dynamic> toMap() => _$TokenDTOToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenDTO _$TokenDTOFromJson(Map<String, dynamic> json) => TokenDTO(
      json['token'] as String,
    );

Map<String, dynamic> _$TokenDTOToJson(TokenDTO instance) => <String, dynamic>{
      'token': instance.token,
    };
