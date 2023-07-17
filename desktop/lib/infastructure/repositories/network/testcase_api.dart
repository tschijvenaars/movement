import 'package:desktop/infastructure/repositories/dtos/testcase_dto.dart';

import '../database/database.dart';
import '../dtos/parsed_response.dart';
import '../dtos/user_sensor_geolocation_data_dto.dart';
import '../dtos/user_test_data_dto.dart';
import 'base_api.dart';

class TestCaseApi extends BaseApi {
  TestCaseApi(Database database) : super("testcasedata/", database);

  Future<ParsedResponse<List<TestCaseDTO>>> getShallowTestCasesAsync() async =>
      getParsedResponse<List<TestCaseDTO>, TestCaseDTO>('shallow', TestCaseDTO.fromMap);

  Future<ParsedResponse<List<UserTestDataDTO>>> getUserTestCasesAsync() async =>
      getParsedResponse<List<UserTestDataDTO>, UserTestDataDTO>('users', UserTestDataDTO.fromMap);

  Future<ParsedResponse<TestCaseDTO>> getDetailTestCasesAsync(int dayId, int userId) async =>
      getParsedResponse<TestCaseDTO, TestCaseDTO>("details/$dayId/$userId", TestCaseDTO.fromMap);

  Future<ParsedResponse<List<UserSensorGeolocationDataDTO>>> getUserSensorGeolocationData() async =>
      getParsedResponse<List<UserSensorGeolocationDataDTO>, UserSensorGeolocationDataDTO>('getUserSensorGeolocationData', UserSensorGeolocationDataDTO.fromMap);
}
