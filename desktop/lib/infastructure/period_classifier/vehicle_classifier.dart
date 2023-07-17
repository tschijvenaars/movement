import 'package:desktop/infastructure/repositories/dtos/vehicle_dto.dart';

import '../notifiers/cluster_notifier.dart';
import '../repositories/database/database.dart';
import '../repositories/dtos/sensor_geolocation_dto.dart';
import 'enums/transport_enum.dart';

class VehicleClassifier {
  VehicleClassifier();

  VehicleDTO getPossibleVehicle(Cluster cluster) {
    if (cluster.transport == Transport.Walking) {
      return VehicleDTO(key: "Walking");
    }

    return VehicleDTO(key: "Unknown");
  }

  Transport getProbableTransport(int averageSpeed, String sensor) {
    final probableTransport = calculateProbableTransport(averageSpeed, sensor);

    return probableTransport;
  }

  int getWalkingThreshold(String sensor) {
    switch (sensor) {
      case "normal":
        return 25;
      case "fused":
        return 15;
      case "balanced":
        return 25;
    }

    return 0;
  }

  Transport calculateProbableTransport(int averageSpeed, String sensor) {
    final walkingThreshold = getWalkingThreshold(sensor);
    if (averageSpeed < walkingThreshold) {
      return Transport.Walking;
    }

    return Transport.Unknown;
  }

  List<ProbableTransport> calculateProbableTransports(int maxSpeed, int averageSpeed) {
    if (maxSpeed > 50 && averageSpeed < 60 && averageSpeed > 10) {
      return createProbability(car: 80, tram: 20, walking: 0, bicycle: 0, unknown: 0);
    }

    if (maxSpeed > 50) {
      return createProbability(car: 20, tram: 80, walking: 0, bicycle: 0, unknown: 0);
    }

    if (maxSpeed < 30 && averageSpeed > 10) {
      return createProbability(car: 0, tram: 0, walking: 0, bicycle: 100, unknown: 0);
    }

    if (maxSpeed < 15) {
      return createProbability(car: 0, tram: 0, walking: 100, bicycle: 0, unknown: 0);
    }

    return createProbability(car: 0, tram: 0, walking: 0, bicycle: 0, unknown: 100);
  }

  List<ProbableTransport> createProbability({required int car, required int tram, required int walking, required int bicycle, required int unknown}) {
    return <ProbableTransport>[
      ProbableTransport(Transport.Car, car),
      ProbableTransport(Transport.Tram, tram),
      ProbableTransport(Transport.Walking, walking),
      ProbableTransport(Transport.Bicycle, bicycle),
      ProbableTransport(Transport.Unknown, unknown),
    ];
  }
}
