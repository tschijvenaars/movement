import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LoginPayload {
  String username;
  String password;

  LoginPayload(this.username, this.password);

  factory LoginPayload.fromMap(Map<String, dynamic> map) =>
      _$LoginPayloadFromJson(map);

  Map<String, dynamic> toMap() => _$LoginPayloadToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginPayload _$LoginPayloadFromJson(Map<String, dynamic> json) => LoginPayload(
      json['username'] as String,
      json['password'] as String,
    );

Map<String, dynamic> _$LoginPayloadToJson(LoginPayload instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };
