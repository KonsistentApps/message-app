import 'package:flutter/foundation.dart';

class Message {
  final String from;
  final String text;
  final String timeStamp;

  Message({
    @required this.from,
    @required this.text,
    @required this.timeStamp,
  });


  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'text': text,
      'timeStamp': timeStamp,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Message(
      from: map['from'],
      text: map['text'],
      timeStamp: map['timeStamp'],
    );
  }
}
