import 'package:latlong2/latlong.dart';
import 'package:movement_algo/src/models/sensor_data.dart';

const int distanceTreshhold = 200;

class StopClassifier {
  static bool isStop(SensorData newSensorData, SensorData referenceSensorData) {
    // TODO: should maybe use distance from stop centroid?
    double distanceInMeters = Distance()(newSensorData.location, referenceSensorData.location);
    newSensorData.distance = distanceInMeters; //TODO: remove this
    return distanceInMeters <= distanceTreshhold;
  }

  //TODO: remove this, it is only used for debugging
  static void setDistance(SensorData newSensorData, SensorData referenceSensorData) {
    double distanceInMeters = Distance()(newSensorData.location, referenceSensorData.location);
    newSensorData.distance = distanceInMeters;
  }
}
