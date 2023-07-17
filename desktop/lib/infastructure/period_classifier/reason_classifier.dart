import 'package:desktop/infastructure/repositories/database/database.dart';
import 'package:desktop/infastructure/repositories/dtos/reason_dto.dart';

import '../repositories/dtos/sensor_geolocation_dto.dart';

class ReasonClassifier {
  ReasonClassifier();

  ReasonDTO getPossibleReason(List<String> pointsOfInterest) {
    return ReasonDTO(key: "Unknown");
  }
}
