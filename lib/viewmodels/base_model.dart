
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:flutter/widgets.dart';

import '../locator.dart';

class BaseModel extends ChangeNotifier {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  User get currentUser => _authenticationService.currentUser;


 /* Map<String, dynamic> _messagesViewModelData = _messagesViewModelData == null ? {"la": "la"} : _messagesViewModelData;
  Map<String, dynamic> get messagesViewModelData => _messagesViewModelData;

  void setMessagesViewModelData(Map<String, dynamic> data) {
    _messagesViewModelData = data;
    notifyListeners();
  }*/


  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
