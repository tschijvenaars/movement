import 'package:desktop/infastructure/repositories/dtos/user_device_dto.dart';
import 'package:desktop/infastructure/repositories/network/verification_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/network/sensor_geo_location_api.dart';
import '../repositories/network/testcase_api.dart';
import '../services/convert_data_structure_service.dart';
import 'generic_notifier.dart';

class UserListNotifier extends StateNotifier<NotifierState> {
  final VerificationApi _verificationApi;
  final ConvertDataStructureService _convertDataStructureService;

  UserListNotifier(this._verificationApi, this._convertDataStructureService) : super(const Initial()) {
    //_convertDataStructureService.syncToNewDatastructure();
    getListAsync();
  }

  Future getListAsync() async {
    state = const Loading();

    final response = await _verificationApi.getUsers();

    state = Loaded<List<UserDeviceDTO>>(response.payload!);
  }
}
