import 'package:desktop/infastructure/repositories/dtos/user_sensor_geolocation_day_data_dto.dart';
import 'package:json_annotation/json_annotation.dart';

class UserSensorGeolocationDataDTO {
  String sdk;
  String brand;
  String model;
  String user;
  int userId;
  List<UserSensorGeolocationDayDataDTO> userTestDaysDataDTO;

  UserSensorGeolocationDataDTO(
      {required this.sdk, required this.brand, required this.model, required this.user, required this.userTestDaysDataDTO, required this.userId});

  factory UserSensorGeolocationDataDTO.fromMap(Map<String, dynamic> map) => UserSensorGeolocationDataDTO(
      sdk: map['Sdk'],
      brand: map['Brand'],
      model: map['Model'],
      user: map['User'],
      userId: map['UserId'],
      userTestDaysDataDTO: UserSensorGeolocationDayDataDTO.fromList(map["UserSensorGeolocationDayDataDTO"]));

  // Map<String, dynamic> toMap() => _$UserDTOToJson(this);
}
