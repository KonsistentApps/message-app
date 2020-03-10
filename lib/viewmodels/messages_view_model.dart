
import 'dart:async';

import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import 'base_model.dart';

class MessagesViewModel extends BaseModel {
  final FireStoreService _fireStoreService = locator<FireStoreService>();

  List<Message> _messages;

  List<Message> get messages => _messages;

  String _userNameConversation;

  String get userNameConversation => _userNameConversation;

  StreamSubscription interlocutorsName;
  StreamSubscription messagesSubscription;


  void initializeData({ @required Map arguments
  }) {
    listenToMessages();
    listenToInterlocutorsName();
    _fireStoreService.startDiscussion(discussionId: arguments["discussionId"]);
    _fireStoreService.getInterlocutor(name: arguments["fullName"]);
  }


  void listenToInterlocutorsName() async{
    setBusy(true);
    interlocutorsName = _fireStoreService.getInterlocutor().listen((name){
        if(name != null && name.isNotEmpty){
          _userNameConversation = name;
          notifyListeners();
        }
      });
      setBusy(false);
  }

  void listenToMessages() async {
    setBusy(true);

    messagesSubscription = _fireStoreService.startDiscussion().listen((messagesData) {
      List<Message> upDatedMessageList = messagesData;
      if (upDatedMessageList != null && upDatedMessageList.length > 0) {
        _messages = upDatedMessageList;

        notifyListeners();
      }
      setBusy(false);
    });
    setBusy(false);

  }

  Future addMessage(
      {@required String messageText,
      @required TextEditingController messageController,
      @required BuildContext context,
      @required ScrollController scrollController}) async {
    if (messageText.length > 0) {
      setBusy(true);
      var addedMessage = await _fireStoreService.addMessage(
          messageText: messageText, documentId: _fireStoreService.docId);
      messageController.clear();
      setBusy(false);

      if (addedMessage is String) {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Could not send the message"),
            content: Text(addedMessage),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    interlocutorsName.cancel();
    messagesSubscription.cancel();
  }


}
