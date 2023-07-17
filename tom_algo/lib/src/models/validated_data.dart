import 'package:latlong2/latlong.dart';

class ValidatedData {
  late bool isStop;
  late bool isConfirmed;
  late DateTime startTime;
  late DateTime endTime;
  late LatLng location;

  ValidatedData.fromTrackedLocation(Map<String, dynamic> map) {
    isStop = true;
    startTime = DateTime.fromMillisecondsSinceEpoch(map['StartTime'], isUtc: true);
    endTime = DateTime.fromMillisecondsSinceEpoch(map['EndTime'], isUtc: true);
    isConfirmed = map['Confirmed'];
    final double _lat = map['Lat'];
    final double _lon = map['Lon'];
    location = LatLng(_lat, _lon);
    print('Stop. Start time $startTime. End time $endTime. Lat $_lat. Lon $_lon');
  }

  ValidatedData.fromTrackedLatLon(Map<String, dynamic> map, DateTime _startTime, bool isConfirmed) {
    isStop = false;
    startTime = _startTime;
    endTime = DateTime.fromMillisecondsSinceEpoch(map['MappedDate']);
    isConfirmed = isConfirmed;
    final double _lat = map['Lat'];
    final double _lon = map['Lon'];
    location = LatLng(_lat, _lon);
    print('Movement. Start time $startTime. End time $endTime. Lat $_lat. Lon $_lon');
  }
}
