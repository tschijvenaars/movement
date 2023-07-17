import 'package:desktop/infastructure/repositories/dtos/sensor_geolocation_dto.dart';
import 'package:desktop/infastructure/repositories/network/google_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/dtos/google_details_dto.dart';
import 'generic_notifier.dart';

class GoogleDetailNotifier extends StateNotifier<NotifierState> {
  final GoogleApi _googleApi;

  GoogleDetailNotifier(this._googleApi) : super(const Initial());

  getDetails(SensorGeolocationDTO dto) async {
    state = const Loading();

    final response = await _googleApi.getPlaceRadiusDetails(dto.lat, dto.lon);

    state = Loaded(GoogleDetailsDTO(response.payload!, dto));
  }
}
