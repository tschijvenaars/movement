import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movement_algo/src/models/sensor_data.dart';
import 'package:movement_algo/src/models/validated_data.dart';

class MockForegroundService {
  final List<ValidatedData> _validatedDataList = [];
  final List<SensorData> _cachedData = [];
  int _index = 0;

  Future<List<SensorData>> get _sensorDataList async {
    if (_cachedData.isEmpty) await _initData();
    return _cachedData;
  }

  Future<void> _initData() async {
    final body = await _downloadData();
    final rawDataList = body['RawData'] as List;
    final validatedData = body['ValidatedData'] as Map;
    print('Parsing data...');
    _parseRawData(rawDataList);
    sortRawData();
    _parseValidatedData(validatedData);
    // _labelRawData();
    print('Parsing complete');
  }

  Future<dynamic> _downloadData() async {
    print('Downloading data from backend...');
    final url = Uri.parse('http://188.166.119.164:8000/api/testcasedata/shallow');
    final response = await http.get(url);
    final result = jsonDecode(response.body);
    final body = jsonDecode(result['Body'])[0];
    print('Download complete');
    return body;
  }

  void _parseRawData(List rawDataList) {
    for (final map in rawDataList) {
      final _sensorData = SensorData.fromJson(map);
      _cachedData.add(_sensorData);
    }
  }

  void sortRawData() {
    _cachedData.sort((a,b)=> a.datetime.compareTo(b.datetime)); 
  }

  void _parseValidatedData(Map validatedDataMap) {
    List trackedLocations = validatedDataMap['TrackedLocations'] as List;
    for (final Map<String, dynamic> trackedLocationMap in trackedLocations) {
      final _trackedLocation = ValidatedData.fromTrackedLocation(trackedLocationMap);
      _validatedDataList.add(_trackedLocation);
      if (trackedLocationMap['TrackedMovements'] != null) {
        for (final Map<String, dynamic> trackedMovementMap in trackedLocationMap['TrackedMovements']) {
          var _movementStartTime = trackedMovementMap['StartTime'];
          if (trackedMovementMap['TrackedLatLons'] != null) {
            for (final Map<String, dynamic> trackedLatLonMap in trackedMovementMap['TrackedLatLons']) {
              final _trackedMovement = ValidatedData.fromTrackedLatLon(trackedLatLonMap, _movementStartTime, _trackedLocation.isConfirmed);
              _validatedDataList.add(_trackedMovement);
              _movementStartTime = _trackedMovement.endTime;
            }
          }
        }
      }
    }
  }

  // bool _isWithinTimeRange(SensorData sensorData, ValidatedData validatedData) {
  //   DateTime _sensorDate = sensorData.datetime;
  //   if (_sensorDate.isAfter(validatedData.startTime) && _sensorDate.isBefore(validatedData.endTime)) return true;
  //   if (_sensorDate.isAtSameMomentAs(validatedData.startTime) || _sensorDate.isAtSameMomentAs(validatedData.endTime)) return true;
  //   return false;
  // }

  // void _labelRawData() {
  //   for (SensorData sensorData in _cachedData) {
  //     sensorData.isValidated = false;
  //     for (final validatedData in _validatedDataList) {
  //       if (_isWithinTimeRange(sensorData, validatedData)) {
  //         sensorData.isValidated = true;
  //         sensorData.isValidated = validatedData.isStop;
  //       }
  //     }
  //   }
  // }

  Future<SensorData?> getNext() async {
    final sensorDataList = await _sensorDataList;
    if (_index > sensorDataList.length - 1) return null;
    final nextSensorData = sensorDataList[_index];
    _index++;
    return nextSensorData;
  }
}
