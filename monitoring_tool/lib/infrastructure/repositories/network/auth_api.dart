import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../dtos/login_payload.dart';
import '../dtos/parsed_response.dart';
import '../dtos/token_dto.dart';
import '../dtos/user_dto.dart';
import 'base_api.dart';
import 'package:http/http.dart' as http;

enum Authenticated { UNINITIALIZED, AUTHENTICATED, UNAUTHENTICATED }

class AuthApi extends BaseApi {
  AuthApi(FlutterSecureStorage storage) : super('', storage);

  Authenticated get isAuthenticated => _isAuthenticated;

  Authenticated _isAuthenticated = Authenticated.UNINITIALIZED;

  Future<ParsedResponse<TokenDTO?>> login(
      String username, String password) async {
    final map = LoginPayload(username, password).toMap();
    final parsedResponse = await getParsedResponse<TokenDTO, TokenDTO>(
        'login', TokenDTO.fromMap,
        payload: map);

    if (parsedResponse.statusCode != 200) {
      _isAuthenticated = Authenticated.UNAUTHENTICATED;
      return parsedResponse;
    }

    _isAuthenticated = Authenticated.AUTHENTICATED;
    final token = parsedResponse.payload!.token;
    await storage.delete(key: 'token');
    await storage.write(key: 'token', value: token);
    return parsedResponse;
  }

  Future<ParsedResponse<UserDTO?>> signup(
      String username, String password) async {
    final map = UserDTO(username, 'unimplemented@cbs.nl', password).toMap();
    return getParsedResponse<UserDTO, UserDTO>('signup', UserDTO.fromMap,
        payload: map);
  }
}
