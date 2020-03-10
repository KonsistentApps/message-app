import 'dart:async';

import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/viewmodels/base_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');

  final CollectionReference _discussionsCollectionReference =
      Firestore.instance.collection('discussions');

  final StreamController<List<Message>> _messagesListController =
      StreamController<List<Message>>.broadcast();

  final StreamController<String> _userConversationNameController = StreamController<String>.broadcast();


  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();



  String _documentID;

  String get docId => _documentID;


  Stream getInterlocutor({String name}){
    _userConversationNameController.add(name);
    return _userConversationNameController.stream;
  }

  Stream startDiscussion({String discussionId}) {
    _documentID = discussionId;
    _discussionsCollectionReference
        .document(discussionId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((messageSnapshot) {
      if (messageSnapshot != null) {
        var messageList = messageSnapshot.documents
            .map((snapshot) => Message.fromMap(snapshot.data))
            .toList();
        _messagesListController.add(messageList);
      } else {
      }
    });
    return _messagesListController.stream;
  }


  Future continueOrStartDiscussionWithUser(
      {@required String userId, @required String currentUserId}) async {
    try {
      var wholeResult =
          await _usersCollectionReference.document(currentUserId).get();
      if (wholeResult.data['discussions'] == null) {
        try {
          await _usersCollectionReference.document(currentUserId).setData({
            'discussions': [
              {"test": "test"}
            ]
          }, merge: true);
        } catch (e) {
          return e.message;
        }
      }
      List<dynamic> result = wholeResult.data['discussions'];

      String discussionId = 'false';
      for (var mapItem in result) {
        if (mapItem['userId'] == userId) {
          discussionId = mapItem['discussionId'];
        }
      }
      if (discussionId != 'false') {


        return {'discussionId': discussionId};
      } else {
        discussionId =
            "disc" + currentUserId.substring(0, 6) + userId.substring(0, 6);
        result.add({'discussionId': discussionId, 'userId': userId});
        var updatedWholeMap;
        updatedWholeMap = wholeResult.data;
        updatedWholeMap['discussions'] = result;
        try {
          await _discussionsCollectionReference
              .document(discussionId)
              .collection('messages')
              .add({
            "text": 'Hello!',
            "from": BaseModel().currentUser.fullName,
            "timestamp": documentIdFromCurrentDate(),
            'something else': "something"
          });
          try {
            await _usersCollectionReference
                .document(currentUserId)
                .setData(updatedWholeMap, merge: false);

            var existingOtherUserData;
            await _usersCollectionReference
                .document(userId)
                .get()
                .then((userData) {
              existingOtherUserData = userData.data;

            });
            existingOtherUserData['discussions']
                .add({'discussionId': discussionId, 'userId': currentUserId});
            await _usersCollectionReference
                .document(userId)
                .setData(existingOtherUserData, merge: false);

            return {'discussionId': discussionId};
          } catch (e) {
            if (e is PlatformException) {
              return e.message;
            }
            return e.toString();
          }
        } catch (e) {
          if (e is PlatformException) {
            return e.message;
          }
          return e.toString();
        }
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future addMessage(
      {@required String messageText, @required String documentId}) async {
    try {
      await _discussionsCollectionReference
          .document(documentId)
          .collection('messages')
          .add({
        "text": messageText,
        "from": BaseModel().currentUser.fullName,
        "timestamp": documentIdFromCurrentDate()
      });
      return true;
      /*await _messageCollectionReference.add({
        "text": messageText,
        "from": BaseModel().currentUser.email,
      });*/
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future getAllUsers() async {
    try {
      var allUsers = await _usersCollectionReference.getDocuments();
      if (allUsers.documents.isNotEmpty) {
        return allUsers.documents
            .map((documentSnapshot) => User.fromData(documentSnapshot.data))
            .toList();
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }
      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      return User.fromData(userData.data);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }



}
