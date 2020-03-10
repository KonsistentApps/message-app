import 'package:flutter/material.dart';

class CenterColumnTopWidget extends StatelessWidget {
  final String title;

  const CenterColumnTopWidget({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontSize: 24),
                ),
                Text("Admin Panel/ eCommerce/ $title")
              ],
            ),
            FloatingActionButton(
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              onPressed: () => showDialog(
                context: context,
                child: AlertDialog(
                  title: Text("Shrink left column"),
                  content: Text("Not yet implemented"),

                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

