import 'package:flutter/material.dart';

import '../repositories/network/auth_api.dart';

class SettingsNotifier extends ChangeNotifier {
  TextEditingController ipTextControl = TextEditingController(text: 'http://192.168.178.33:8000');
  String ipAddress = 'http://192.168.178.33:8000';
  //http://192.168.1.202:8000

  TextEditingController usernameTextControl = TextEditingController();

  TextEditingController passwordTextControl = TextEditingController();

  final AuthApi _authApi;
  SettingsNotifier(this._authApi);

  AuthApi get authApi => _authApi;

  bool loginButtonDisabled = false;

  /// Sets server IP based on the input context of the IP-textfield
  void setServerIP() {
    if (ipTextControl.text != '') {
      _authApi.serverSocketAddress = ipTextControl.text;
    }
    print('Saved!');
    notifyListeners();
  }

  /// Sets textfield and internal field of IP to the IP of the Droplet.
  void setDefaultIP() {
    ipTextControl.text = 'http://192.168.178.33:8000/';
    _authApi.serverSocketAddress = 'http://192.168.178.33:8000/';
    print('Restored Default!');
    notifyListeners();
  }

  /// Try to log in using [username] and [password] and if true, it sets the general authentication status as authenticated.
  Future<void> loginAdmin(String username, String password) async {
    try {
      final response = await _authApi.login(username, password);
    } catch (error) {
      print('Error [$error]');
      return;
    }
    if (_authApi.isAuthenticated == Authenticated.AUTHENTICATED) {
      loginButtonDisabled = true;
    }
    notifyListeners();
  }
}
