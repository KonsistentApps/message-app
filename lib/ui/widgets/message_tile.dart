import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String from;
  final String text;
  final bool me;

  const MessageTile({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
        me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(from),
          Material(
            color: me ? Colors.teal : Colors.red,
            elevation: 6,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(text),
            ),
          )
        ],
      ),
    );
  }
}
