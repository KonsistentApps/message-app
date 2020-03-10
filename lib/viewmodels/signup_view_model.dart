import 'package:chat_app/constants/route_names.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/services/dialog_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import 'base_model.dart';

class SignUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  String _selectedRole = 'Select a User Role';

  String get selectedRole => _selectedRole;

  void setSelectedRole(dynamic role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future signUp({
    @required String email,
    @required String password,
    @required String fullName,
    @required BuildContext context,
  }) async {
    setBusy(true);
    var result = await _authenticationService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        role: _selectedRole);
    setBusy(false);

    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(SelectDiscussionRoute);
      } else {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text("\nSign Up Failure\n"),
            content: Text("General sign up failure. Please try again later"),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("\nSign Up Failure\n"),
          content: Text(result),
        ),
      );
    }
  }
}
