import 'package:movement_algo/src/models/enums/sensor_type_enum.dart';
import 'package:movement_algo/src/models/sensor_data.dart';

class NoiseClassifier {
  static bool _hasLowAccuracy(double accuracy) {
    return accuracy > 40;
  }

  static bool _hasUnnaturalSpeed(double speed) {
    return speed > 300;
  }

  static bool _badSensor(SensorType sensorType) {
    return sensorType != SensorType.gps;
  }

  static bool isNoise(SensorData sensorData) {
    if (_hasLowAccuracy(sensorData.accuracy)) return true;
    if (_hasUnnaturalSpeed(sensorData.speed)) return true;
    if (_badSensor(sensorData.sensorType)) return true;
    return false;
  }
}
