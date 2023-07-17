import 'dart:math';

import 'package:desktop/infastructure/notifiers/google_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../repositories/dtos/location_dto.dart';
import '../repositories/dtos/location_map_dto.dart';
import '../repositories/dtos/sensor_geolocation_dto.dart';
import '../repositories/dtos/user_sensor_geolocation_data_dto.dart';
import '../repositories/dtos/user_sensor_geolocation_day_data_dto.dart';
import '../repositories/dtos/user_test_data_dto.dart';
import '../repositories/dtos/user_test_day_data_dto.dart';
import 'generic_notifier.dart';

class Counter {
  Counter(this.hour, this.count);

  int hour, count;
}

class LocationMapNotifier extends StateNotifier<NotifierState> {
  LocationMapNotifier(this._googleDetailNotifier) : super(const Initial());

  final GoogleDetailNotifier _googleDetailNotifier;

  Future showOnMapAsync(UserSensorGeolocationDayDataDTO day) async {
    state = const Loading();
    state = Loaded<UserSensorGeolocationDayDataDTO>(day);
  }

  List<SensorGeolocationDTO> getBestSensor(List<List<SensorGeolocationDTO>> list) {
    var firstDateInList = DateTime.fromMillisecondsSinceEpoch(list[0][0].createdOn);
    var days = List<List<int>>.empty(growable: true);
    var actualCounters = List<int>.empty(growable: true);
    var highest = 0;
    var index = 0;

    for (var i = 0; i < list.length; i++) {
      var date = DateTime(firstDateInList.year, firstDateInList.month, firstDateInList.day, 0);
      var counter = List<int>.empty(growable: true);
      var actualCount = 0;

      for (var h = 1; h <= 24; h++) {
        var itemsInHour = list[i]
            .where((element) => element.createdOn >= date.millisecondsSinceEpoch && element.createdOn <= date.millisecondsSinceEpoch + (3600 * 1000))
            .toList();

        counter.add(itemsInHour.length);
        date = date.add(const Duration(hours: 1));

        if (itemsInHour.length > 40) {
          actualCount++;
        }
      }

      actualCounters.add(actualCount);

      if (actualCount > highest) {
        highest = actualCount;
        index = i;
      }

      days.add(counter);
    }

    return list[index];
  }

  LocationMapDTO getDensityMapDTO(List<SensorGeolocationDTO> data) {
    var locationMapDTO = LocationMapDTO(_getDensityMarkers(data), []);

    return locationMapDTO;
  }

  LocationMapDTO getRawLocationMapDTO(List<SensorGeolocationDTO> data) {
    var locationMapDTO = LocationMapDTO(_getRawMarkers(data), []);

    return locationMapDTO;
  }

  LocationMapDTO getCalculatedSpeedLocationMapDTO(List<SensorGeolocationDTO> data) {
    var locationMapDTO = LocationMapDTO(_getCalculatedSpeedMarkers(data), []);

    return locationMapDTO;
  }

  LocationMapDTO getSpeedLocationMapDTO(List<SensorGeolocationDTO> data) {
    var locationMapDTO = LocationMapDTO(_getSpeedMarkers(data), []);

    return locationMapDTO;
  }

  LocationMapDTO getClusterCalculatedSpeedLocationMapDTO(List<SensorGeolocationDTO> data) {
    var locationMapDTO = LocationMapDTO(_getClusterCalculatedSpeedMarkers(data), []);

    return locationMapDTO;
  }

  LocationMapDTO getAccuracyLocationMapDTO(List<SensorGeolocationDTO> data) {
    var locationMapDTO = LocationMapDTO(_getAccuracyMarkers(data), []);

    return locationMapDTO;
  }

  List<Polyline> _getPolylines(List<SensorGeolocationDTO> locations) {
    var latlngs = <Polyline>[];
    var polyline = Polyline(strokeWidth: 4.0, color: Colors.blue, points: []);
    for (var location in locations) {
      polyline.points.add(LatLng(location.lat, location.lon));
    }

    latlngs.add(polyline);

    return latlngs;
  }

  List<Marker> _getRawMarkers(List<SensorGeolocationDTO> locations) {
    var markers = <Marker>[];

    for (var i = 0; i < locations.length - 5; i += 5) {
      var averageSpeed = getMedian(locations.sublist(i, i + 5));
      for (var j = 0; j < 5; j++) {
        var dto = locations[i + j];

        var marker = Marker(
            width: 5.0,
            height: 5.0,
            point: LatLng(dto.lat, dto.lon),
            builder: (ctx) => InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.blue,
                    ),
                    alignment: Alignment.center,
                  ),
                  onTap: () {
                    _googleDetailNotifier.getDetails(dto);
                  },
                ));

        markers.add(marker);
      }
    }

    return markers;
  }

  // List<Marker> _getDensityMarkers(List<LocationDTO> locations) {
  //   var markers = <Marker>[];
  //   // var densityList = <double>[];
  //   var densityAverage = _calculateAverageDensity(locations);

  //   for (var i = 3; i < locations.length; i++) {
  //     // var distance = _calculateDistance(locations[i - 3].lat, locations[i - 3].lon, locations[i].lat, locations[i].lon);
  //     // var timeDifferenceInSeconds = (locations[i].date - locations[i - 3].date) / 1000 / 60;
  //     // var density = distance * timeDifferenceInSeconds;
  //     // densityList.add(density);
  //     var dto = locations[i];

  //     var marker = Marker(
  //         width: 5.0,
  //         height: 5.0,
  //         point: LatLng(dto.lat, dto.lon),
  //         builder: (ctx) => Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(40),
  //                 color: getColorBasedOnDensity(dto.density.toInt(), dto.accuracy.toInt(), densityAverage.toInt()),
  //               ),
  //               alignment: Alignment.center,
  //             ));

  //     markers.add(marker);
  //   }

  //   // densityAverage = densityList.reduce((a, b) => a + b) / densityList.length;

  //   return markers;
  // }

  List<Marker> _getAccuracyMarkers(List<SensorGeolocationDTO> locations) {
    var markers = <Marker>[];

    for (var location in locations) {
      var marker = Marker(
          width: 5.0,
          height: 5.0,
          point: LatLng(location.lat, location.lon),
          builder: (ctx) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: getColorBasedOnAccuracy(location.density),
                ),
                alignment: Alignment.center,
              ));

      markers.add(marker);
    }

    return markers;
  }

  List<Marker> _getDensityMarkers(List<SensorGeolocationDTO> locations) {
    var markers = <Marker>[];

    for (var location in locations) {
      var marker = Marker(
          width: 5.0,
          height: 5.0,
          point: LatLng(location.lat, location.lon),
          builder: (ctx) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: getColorBasedOnDensity(location.density),
                ),
                alignment: Alignment.center,
              ));

      markers.add(marker);
    }

    return markers;
  }

  double _calculateAverageDensity(List<SensorGeolocationDTO> locations) {
    var itemsInHour = locations.sublist(0, 100);
    var densityList = <double>[];
    var densityAverage = 0.0;

    for (var i = 3; i < itemsInHour.length; i++) {
      var distance = _calculateDistance(locations[i - 3].lat, locations[i - 3].lon, locations[i].lat, locations[i].lon);
      var timeDifferenceInSeconds = (locations[i].createdOn - locations[i - 3].createdOn) / 1000 / 60;
      var density = distance * timeDifferenceInSeconds;
      densityList.add(density);
    }

    densityAverage = densityList.reduce((a, b) => a + b) / densityList.length;

    return densityAverage;
  }

  List<Marker> _getClusterCalculatedSpeedMarkers(List<SensorGeolocationDTO> locations) {
    var markers = <Marker>[];

    for (var i = 0; i < locations.length - 5; i += 5) {
      var averageSpeed = getMedian(locations.sublist(i, i + 5));
      for (var j = 0; j < 5; j++) {
        var dto = locations[i + j];

        var marker = Marker(
            width: 5.0,
            height: 5.0,
            point: LatLng(dto.lat, dto.lon),
            builder: (ctx) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: getColorBasedOnCluster(averageSpeed, dto.accuracy.toInt()),
                  ),
                  alignment: Alignment.center,
                ));

        markers.add(marker);
      }
    }

    return markers;
  }

  int getAverage(List<SensorGeolocationDTO> locations) {
    var total = 0;
    for (var i = 0; i < locations.length; i++) {
      total += locations[i].calculatedSpeed.toInt();
    }

    var average = total / locations.length;

    return average.toInt();
  }

  int getMedian(List<SensorGeolocationDTO> locations) {
    locations.sort((a, b) => a.calculatedSpeed.compareTo(b.calculatedSpeed));
    var median = locations[2].calculatedSpeed;

    return median.isNaN ? 0 : median.toInt();
  }

  List<Marker> _getCalculatedSpeedMarkers(List<SensorGeolocationDTO> locations) {
    var markers = <Marker>[];

    for (var dto in locations) {
      var marker = Marker(
          width: 5.0,
          height: 5.0,
          point: LatLng(dto.lat, dto.lon),
          builder: (ctx) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: getColorBasedOnCalculatedSpeed(dto),
                ),
                alignment: Alignment.center,
              ));

      markers.add(marker);
    }

    return markers;
  }

  List<Marker> _getSpeedMarkers(List<SensorGeolocationDTO> locations) {
    var markers = <Marker>[];

    for (var dto in locations) {
      var marker = Marker(
          width: 5.0,
          height: 5.0,
          point: LatLng(dto.lat, dto.lon),
          builder: (ctx) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: getColorBasedOnSpeed(dto),
                ),
                alignment: Alignment.center,
              ));

      markers.add(marker);
    }

    return markers;
  }

  LocationMapDTO getLocationDensityMap(List<SensorGeolocationDTO> locations) {
    var markers = _getDensityMarkers(locations);

    return LocationMapDTO(markers, []);
  }

  getColorBasedOnCalculatedSpeed(SensorGeolocationDTO dto) {
    var speed = dto.calculatedSpeed.isNaN ? 0 : dto.calculatedSpeed.toInt();
    var isAccurate = dto.accuracy < 20;

    if (speed == 1 && isAccurate) {
      return Colors.white;
    }

    if (speed == 2 && isAccurate) {
      return Colors.grey[300];
    }

    if (speed == 3 && isAccurate) {
      return Colors.grey[600];
    }

    if (speed == 4 && isAccurate) {
      return Colors.grey[900];
    }

    if (speed == 5 && isAccurate) {
      return Colors.black;
    }

    if (speed > 5 && speed <= 10 && isAccurate) {
      return Colors.blue;
    }

    if (speed > 10 && speed <= 30 && isAccurate) {
      return Colors.green;
    }

    if (speed > 30 && speed <= 50 && isAccurate) {
      return Colors.yellow;
    }

    if (speed > 50 && speed <= 80 && isAccurate) {
      return Colors.orange;
    }

    if (speed > 80 && isAccurate) {
      return Colors.red;
    }
  }

  getColorBasedOnDensityAverage(int density, int accuracy, int densityAverage) {
    var isAccurate = accuracy < 20;

    if (density > densityAverage && isAccurate) {
      return Color.fromARGB(255, 112, 177, 230);
    }

    return;

    if (density > densityAverage + 20 && density <= densityAverage + 40 && isAccurate) {
      return Colors.red;
    }

    if (density > densityAverage + 40 && density <= densityAverage + 60 && isAccurate) {
      return Colors.orange;
    }

    if (density > densityAverage + 60 && isAccurate) {
      return Colors.yellow;
    }
  }

  getColorBasedOnSpeed(SensorGeolocationDTO dto) {
    var speed = dto.speed.toInt();
    var isAccurate = dto.accuracy < 20;

    if (speed == 1 && isAccurate) {
      return Colors.white;
    }

    if (speed == 2 && isAccurate) {
      return Colors.grey[300];
    }

    if (speed == 3 && isAccurate) {
      return Colors.grey[600];
    }

    if (speed == 4 && isAccurate) {
      return Colors.grey[900];
    }

    if (speed == 5 && isAccurate) {
      return Colors.black;
    }

    if (speed > 5 && speed <= 10 && isAccurate) {
      return Colors.blue;
    }

    if (speed > 10 && speed <= 30 && isAccurate) {
      return Colors.green;
    }

    if (speed > 30 && speed <= 50 && isAccurate) {
      return Colors.yellow;
    }

    if (speed > 50 && speed <= 80 && isAccurate) {
      return Colors.orange;
    }

    if (speed > 80 && isAccurate) {
      return Colors.red;
    }
  }

  getColorBasedOnCluster(int speed, int accuracy) {
    var isAccurate = accuracy < 20;

    if (speed == 1 && isAccurate) {
      return Colors.white;
    }

    if (speed == 2 && isAccurate) {
      return Colors.grey[300];
    }

    if (speed == 3 && isAccurate) {
      return Colors.grey[600];
    }

    if (speed == 4 && isAccurate) {
      return Colors.grey[900];
    }

    if (speed == 5 && isAccurate) {
      return Colors.black;
    }

    if (speed > 5 && speed <= 10 && isAccurate) {
      return Colors.blue;
    }

    if (speed > 10 && speed <= 30 && isAccurate) {
      return Colors.green;
    }

    if (speed > 30 && speed <= 50 && isAccurate) {
      return Colors.yellow;
    }

    if (speed > 50 && speed <= 80 && isAccurate) {
      return Colors.orange;
    }

    if (speed > 80 && isAccurate) {
      return Colors.red;
    }
  }

  getColorBasedOnDensity(double density) {
    if (density >= 0.0 && density <= 0.1) {
      return Colors.green;
    }

    if (density >= 0.2 && density <= 0.3) {
      return Colors.tealAccent;
    }

    if (density >= 0.4 && density <= 0.5) {
      return Colors.teal;
    }

    if (density >= 0.6 && density <= 0.7) {
      return Colors.blueAccent;
    }

    if (density >= 0.8 && density <= 0.9) {
      return Colors.blue;
    }

    if (density >= 0.9 && density <= 1.0) {
      return Colors.indigo;
    }

    if (density > 1.0 && density <= 10) {
      return Colors.purple;
    }

    if (density > 10 && density <= 30) {
      return Colors.pink;
    }

    if (density > 30 && density <= 50) {
      return Colors.red;
    }

    if (density > 50 && density <= 80) {
      return Colors.orange;
    }

    if (density > 80) {
      return Colors.yellow;
    }
  }

  getColorBasedOnAccuracy(double accuracy) {
    if (accuracy <= 1.0) {
      return Colors.green;
    }

    if (accuracy > 1.0 && accuracy <= 10) {
      return Colors.teal;
    }

    if (accuracy > 10 && accuracy <= 30) {
      return Colors.blue;
    }

    if (accuracy > 30 && accuracy <= 50) {
      return Colors.indigo;
    }

    if (accuracy > 50 && accuracy <= 80) {
      return Colors.purple;
    }

    if (accuracy > 80) {
      return Colors.red;
    }
  }

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    return 12742 * asin(sqrt(a)) * 1000;
  }
}
