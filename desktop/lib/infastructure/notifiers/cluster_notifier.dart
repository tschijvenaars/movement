import 'dart:math';

import 'package:desktop/infastructure/period_classifier/vehicle_classifier.dart';
import 'package:desktop/infastructure/repositories/database/database.dart';
import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../presentation/location_map.dart';
import '../period_classifier/enums/transport_enum.dart';
import '../repositories/dtos/location_dto.dart';
import '../repositories/dtos/location_map_dto.dart';
import '../repositories/dtos/user_test_data_dto.dart';
import '../repositories/dtos/user_test_day_data_dto.dart';
import 'generic_notifier.dart';

class ClusterNotifier extends StateNotifier<NotifierState> {
  final VehicleClassifier _vehicleClassifier;

  ClusterNotifier(this._vehicleClassifier) : super(const Initial());

  //fused
  //normal
  //balanced
  void createClusters(List<List<SensorGeolocationDTO>> data) {
    state = const Loading();

    final clusters = List<List<Cluster>>.empty(growable: true);

    var fusedCluster = createCalculatedSpeedCluster(data[0]);
    var normalCluster = createCalculatedSpeedCluster(data[1]);
    var balancedCluster = createCalculatedSpeedCluster(data[2]);

    clusters.addAll([fusedCluster, normalCluster, balancedCluster]);

    state = Loaded<List<List<Cluster>>>(clusters);
  }

  List<Cluster> createCalculatedSpeedCluster(List<SensorGeolocationDTO> data) {
    final clusters = List<Cluster>.empty(growable: true);
    var counter = 0;
    var moving = false;

    data.removeWhere((element) => element.accuracy > 30);

    for (var i = 0; i < data.length - 5; i += 5) {
      var medianSpeed = getMedian(data.sublist(i, i + 5));
      for (var j = 0; j < 5; j++) {
        var isMoving = this.isMoving(medianSpeed);
        var stoppedMoving = this.stoppedMoving(isMoving, moving);
        var counterIsBigEnough = i + j - counter > 30;

        if (stoppedMoving) {
          var cluster = distillCluster(data.sublist(counter, i + j));

          clusters.add(cluster);
        }

        if (startedMoving(isMoving, moving)) {
          counter = i + j;
        }

        moving = isMoving;
      }
    }

    return clusters;
  }

  bool stoppedMoving(bool isMoving, bool moving) {
    return !isMoving && moving;
  }

  bool startedMoving(bool isMoving, bool moving) {
    return isMoving && !moving;
  }

  bool isMoving(int calculatedSpeed) {
    return calculatedSpeed > 3;
  }

  int getMedian(List<SensorGeolocationDTO> locations) {
    locations.sort((a, b) => a.calculatedSpeed.compareTo(b.calculatedSpeed));
    var median = locations[2].calculatedSpeed;

    return median.isNaN ? 0 : median.toInt();
  }

  Cluster distillCluster(List<SensorGeolocationDTO> data) {
    if (data.length == 0) {
      return Cluster([""], DateTime.now(), DateTime.now(), 0, 0, data.length, data, 0, [], [], Transport.Unknown);
    }

    var averageSpeed = data.map((m) => m.calculatedSpeed).reduce((a, b) => a + b) / data.length;
    var maxSpeed = data.map((d) => d.calculatedSpeed).reduce(max);
    var amountOfTime = (data.last.createdOn - data.first.createdOn) / 1000;
    var probableTransports = calculateProbableTransports(maxSpeed.toInt(), averageSpeed.toInt());
    var cluster = Cluster([""], DateTime.now(), DateTime.now(), averageSpeed.toInt(), amountOfTime.toInt(), data.length, data, maxSpeed.toInt(),
        probableTransports, [], Transport.Unknown);

    return cluster;
  }

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    return 12742 * asin(sqrt(a)) * 1000;
  }

  int _calculateSpeed(DateTime startTime, DateTime endTime, double distance) {
    var timeDifferenceInSeconds = (endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch) * 1000;
    var speed = distance / timeDifferenceInSeconds;

    return speed.toInt();
  }

  LocationMapDTO createLocationMap(List<Cluster> clusters) {
    var latlngs = <Polyline>[];

    for (var cluster in clusters) {
      var polyline = Polyline(strokeWidth: 4.0, color: getColorBasedOnCalculatedSpeed(cluster.averageSpeed), points: []);

      for (var location in cluster.locations) {
        polyline.points.add(LatLng(location.lat, location.lon));
      }

      latlngs.add(polyline);
    }

    var locationMapDTO = LocationMapDTO(_getMarkers(clusters.isNotEmpty ? [clusters[0].locations[0]] : []), latlngs);

    return locationMapDTO;
  }

  LocationMapDTO createVehicleMap(List<Cluster> clusters, String sensor) {
    var latlngs = <Polyline>[];

    for (var cluster in clusters) {
      var polyline = Polyline(strokeWidth: 4.0, color: getColorBasedOnVehicleProbability(cluster, sensor), points: []);

      for (var location in cluster.locations) {
        polyline.points.add(LatLng(location.lat, location.lon));
      }

      latlngs.add(polyline);
    }

    var locationMapDTO = LocationMapDTO(_getMarkers(clusters.isNotEmpty ? [clusters[0].locations[0]] : []), latlngs);

    return locationMapDTO;
  }

  Color randomGenerator() {
    final List<Color> circleColors = [Colors.red, Colors.blue, Colors.green, Colors.purple, Colors.yellow, Colors.orange, Colors.brown];
    final color = circleColors[Random().nextInt(6)];

    return color;
  }

  List<Marker> _getMarkers(List<SensorGeolocationDTO> locations) {
    var markers = <Marker>[];

    for (var dto in locations) {
      var marker = Marker(
          width: 5.0,
          height: 5.0,
          point: LatLng(dto.lat, dto.lon),
          builder: (ctx) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.blue,
                ),
                alignment: Alignment.center,
              ));

      markers.add(marker);
    }

    return markers;
  }

  double _calculateAverageDensity(List<LocationDTO> locations) {
    var itemsInHour = locations.sublist(0, 100);
    var densityList = <double>[];
    var densityAverage = 0.0;

    for (var i = 3; i < itemsInHour.length; i++) {
      var distance = _calculateDistance(locations[i - 3].lat, locations[i - 3].lon, locations[i].lat, locations[i].lon);
      var timeDifferenceInSeconds = (locations[i].date - locations[i - 3].date) / 1000 / 60;
      var density = distance * timeDifferenceInSeconds;
      densityList.add(density);
    }

    densityAverage = densityList.reduce((a, b) => a + b) / densityList.length;

    return densityAverage;
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

  getColorBasedOnCalculatedSpeed(int speed) {
    if (speed == 0) {
      return Colors.white;
    }

    if (speed == 1) {
      return Colors.grey[100];
    }

    if (speed == 2) {
      return Colors.grey[200];
    }

    if (speed == 3) {
      return Colors.grey[600];
    }

    if (speed == 4) {
      return Colors.grey[900];
    }

    if (speed == 5) {
      return Colors.black;
    }

    if (speed > 5 && speed <= 10) {
      return Colors.blue;
    }

    if (speed > 10 && speed <= 30) {
      return Colors.green;
    }

    if (speed > 30 && speed <= 50) {
      return Colors.yellow;
    }

    if (speed > 50 && speed <= 80) {
      return Colors.orange;
    }

    if (speed > 80) {
      return Colors.red;
    }
  }

  getColorBasedOnVehicleProbability(Cluster cluster, String sensor) {
    final transport = _vehicleClassifier.getProbableTransport(cluster.averageSpeed, sensor);

    if (transport == Transport.Car) {
      return Colors.blue;
    }

    if (transport == Transport.Tram) {
      return Colors.green;
    }

    if (transport == Transport.Walking) {
      return Colors.yellow;
    }

    if (transport == Transport.Bicycle) {
      return Colors.orange;
    }

    if (transport == Transport.Unknown) {
      return Colors.black;
    }
  }
}

class Cluster {
  List<SensorGeolocationDTO> locations;
  List<String> potentialTransport;
  DateTime starttime, endtime;
  int averageSpeed, amountOfTime, amountOfPoints, maxSpeed;
  List<ProbableTransport> probableTransports;
  Transport transport;
  List<String> pointsOfInterest;

  Cluster(this.potentialTransport, this.starttime, this.endtime, this.averageSpeed, this.amountOfTime, this.amountOfPoints, this.locations, this.maxSpeed,
      this.probableTransports, this.pointsOfInterest, this.transport);
}

class ProbableTransport {
  Transport transport;
  int probability;

  ProbableTransport(this.transport, this.probability);
}
