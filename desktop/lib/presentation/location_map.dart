import 'package:desktop/infastructure/repositories/dtos/location_map_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMap extends StatelessWidget {
  LocationMap(this.dto);

  final LocationMapDTO dto;

  @override
  Widget build(BuildContext context) {
    return _buildLocationList(context, dto);
  }

  Widget _buildLocationList(BuildContext context, LocationMapDTO dto) {
    if (dto.markers.isEmpty) {
      return generateEmptyMap(context);
    }

    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width * 0.22,
        child: Stack(children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(dto.markers.last.point.latitude, dto.markers.last.point.longitude),
              zoom: 9.0,
            ),
            layers: [
              TileLayerOptions(urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(
                markers: dto.markers,
              ),
              PolylineLayerOptions(polylines: dto.polylines),
            ],
          ),
        ]));
  }

  Widget generateEmptyMap(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width * 0.12,
        child: Stack(children: [
          FlutterMap(
            options: MapOptions(
              zoom: 45.0,
            ),
            layers: [
              TileLayerOptions(urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(
                markers: dto.markers,
              ),
              PolylineLayerOptions(polylines: dto.polylines),
            ],
          ),
        ]));
  }
}
