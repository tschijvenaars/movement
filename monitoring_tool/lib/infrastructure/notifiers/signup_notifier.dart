import 'dart:async';

import 'package:flutter/material.dart';

import '../repositories/network/auth_api.dart';

enum SignupError { UNINITIALIZED, ERROR, NOERROR }

class SignupNotifier extends ChangeNotifier {
  final AuthApi _authApi;

  SignupNotifier(this._authApi);

  SignupError get errorFileLoading => _errorFileLoading;

  SignupError _errorFileLoading = SignupError.UNINITIALIZED;

  SignupError get errorBatchSignup => _errorBatchSignup;

  SignupError _errorBatchSignup = SignupError.UNINITIALIZED;

  List<List<dynamic>> get signupData => _signupData;

  late List<List<dynamic>> _signupData;

  TextEditingController usernameTextControl = TextEditingController();

  TextEditingController passwordTextControl = TextEditingController();

  bool get succesfullyAdded => _succesfullyAdded;
  bool _succesfullyAdded = false;
  bool get shouldDisplaySingleUserWarning => _shouldDisplaySingleUserWarning;
  bool _shouldDisplaySingleUserWarning = false;

  /// Sets File Loading to SignupError [err].
  void setFileLoadingError(SignupError err) {
    _errorFileLoading = err;
    notifyListeners();
  }

  /// Sets Batch Signup Loading to SignupError [err].
  void setBatchSignupError(SignupError err) {
    _errorBatchSignup = err;
    notifyListeners();
  }

  /// Signing up user using values of the textfields.
  Future<void> signUpUser() async {
    if (usernameTextControl.text != '' &&
        passwordTextControl.text != '' &&
        usernameTextControl.text.length > 2 &&
        passwordTextControl.text.length > 2 &&
        RegExp(r'^[A-Za-z0-9]+$').hasMatch(usernameTextControl.text) &&
        RegExp(r'^[A-Za-z0-9]+$').hasMatch(passwordTextControl.text)) {
      displaySingleUserWarning(false);
      final credentials = await _authApi.signup(usernameTextControl.text, passwordTextControl.text);
      notifyUserSignupSuccess(true);
      Timer(const Duration(seconds: 5), () {
        notifyUserSignupSuccess(false);
      });
    } else {
      displaySingleUserWarning(true);
    }
  }

  void notifyUserSignupSuccess(bool success) {
    _succesfullyAdded = success;
    notifyListeners();
  }

  void displaySingleUserWarning(bool success) {
    _shouldDisplaySingleUserWarning = success;
    notifyListeners();
  }

  void loadSignupInfo(List<List<dynamic>> signup) {
    try {
      _signupData = signup;
      setFileLoadingError(SignupError.NOERROR);
    } catch (e) {
      setFileLoadingError(SignupError.ERROR);
    }
  }

  Future<void> signupBatch() async {
    if (signupData != null) {
      for (var row in _signupData) {
        if (row.length != 2) {
          setBatchSignupError(SignupError.ERROR);
          Timer(const Duration(seconds: 5), () {
            setBatchSignupError(SignupError.UNINITIALIZED);
          });
          return;
        }
      }

      for (var row in _signupData) {
        await _authApi.signup(row[0], row[1]);
      }
      setBatchSignupError(SignupError.NOERROR);
    }
  }
}
