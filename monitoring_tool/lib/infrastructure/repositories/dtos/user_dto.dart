import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UserDTO {
  String username;
  String email;
  String password;

  UserDTO(this.username, this.email, this.password);

  factory UserDTO.fromMap(Map<String, dynamic> map) => _$UserDTOFromJson(map);

  Map<String, dynamic> toMap() => _$UserDTOToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDTO _$UserDTOFromJson(Map<String, dynamic> json) => UserDTO(
      json['Username'] as String,
      json['Email'] as String,
      json['Password'] as String,
    );

Map<String, dynamic> _$UserDTOToJson(UserDTO instance) => <String, dynamic>{
      'Username': instance.username,
      'Email': instance.email,
      'Password': instance.password,
    };
