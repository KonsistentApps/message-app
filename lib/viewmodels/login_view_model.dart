import 'package:chat_app/constants/route_names.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/services/dialog_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future login({
    @required String email,
    @required String password,
    @required BuildContext context,
  }) async {
    setBusy(true);
    var result = await _authenticationService.loginWithEmail(
      email: email,
      password: password,
    );
    setBusy(false);
    if (result is bool) {
      if (result) {
        _navigationService.navigateTo(SelectDiscussionRoute);
      } else {
        showDialog(
            context: context,
            child: AlertDialog(
              title: Text("Login Failure"),
              content: Text("General login failure. Please try again later"),
            ));
      }
    } else {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("\nLogin Failure\n"),
            content: Text(result),
          ));
    }
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(SignUpViewRoute);
  }
}
