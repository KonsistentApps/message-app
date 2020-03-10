import 'package:chat_app/constants/route_names.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/services/dialog_service.dart';
import 'package:chat_app/services/firestore_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import 'base_model.dart';

class SelectDiscussionViewModel extends BaseModel {
  final FirestoreService _fireStoreService = locator<FirestoreService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  List<User> _usersList;

  List<User> get userList => _usersList;

  Future logout() async {
    setBusy(true);
    var result = await _authenticationService.logout();
    if (result is String) {
      await _dialogService.showDialog(
        title: "Sign out failed",
        description: result,
      );
      setBusy(false);
    } else {
      await _navigationService.navigateTo(LoginViewRoute);
      setBusy(false);
    }
  }

  Future continueOrStartDiscussion(int index, BuildContext context) async {
    setBusy(true);
    var discussionId =
        await _fireStoreService.continueOrStartDiscussionWithUser(
            currentUserId: BaseModel().currentUser.id,
            userId: userList[index].id);
    if (discussionId != String) {
      Map<String, dynamic> messageData = {
        'discussionId': discussionId['discussionId'],
        'fullName': userList[index].fullName
      };
      _navigationService.navigateTo(MessagesRoute, arguments: messageData);
      setBusy(false);
    } else {
      setBusy(false);
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Error starting the discussion"),
          content: Text(discussionId),
        ),
      );
    }
  }

  Future fetchAllUsers(BuildContext context) async {
    setBusy(true);
    var allUsers = await _fireStoreService.getAllUsers();
    setBusy(false);
    if (allUsers is List<User>) {
      List<User> usersListWithoutSelf = [];
      for (var user in allUsers) {
        if (user.id != BaseModel().currentUser.id) {
          usersListWithoutSelf.add(user);
        }
        _usersList = usersListWithoutSelf;
        notifyListeners();
      }
    } else
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Error fetching the Users"),
          content: Text(allUsers),
        ),
      );
  }
}
