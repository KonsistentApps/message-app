import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      initialRoute: MyHomePage.id,
      routes: {
        MyHomePage.id: (context) => MyHomePage(),
        Registration.id: (context) => Registration(),
        Login.id: (context) => Login(),
        Chat.id: (context) => Chat(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  static const String id = "HOMESCREEN";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  width: 100,
                  child: Image.asset('assets/Button-filled-monochrome.png'),
                ),
              ),
              Text(
                "Admin Chat",
                style: TextStyle(fontSize: 40),
              )
            ],
          ),
          SizedBox(
            height: 50,
          ),
          CustomButton(
            text: "Log in",
            callback: () {
              Navigator.of(context).pushNamed(Login.id);
            },
          ),
          CustomButton(
            text: "Register",
            callback: () {
              Navigator.of(context).pushNamed(Registration.id);
            },
          )
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  const CustomButton({Key key, this.callback, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Material(
        color: Colors.blueGrey,
        elevation: 6,
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.hardEdge,
        child: MaterialButton(
          onPressed: callback,
          minWidth: 200,
          height: 45,
          child: Text(text),
        ),
      ),
    );
  }
}

class Registration extends StatefulWidget {
  static const String id = "REGISTRATION";

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String email;
  String password;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> registerUser() async {
    try {
      AuthResult user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      Navigator.pushNamed(context, Chat.id, arguments: user);
    } catch (e) {
      //print(e.toString());
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("\n${e.message}\n"),
            //content: new Text(""),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Chat"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset("assets/Button-filled-monochrome.png"),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          TextField(
            onChanged: (value) => email = value,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Enter your Email...",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          TextField(
            obscureText: true,
            autocorrect: false,
            onChanged: (value) => password = value,
            decoration: InputDecoration(
              hintText: "Enter your Password...",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          CustomButton(
            text: "Register",
            callback: () => registerUser(),
          )
        ],
      ),
    );
  }
}

class Login extends StatefulWidget {
  static const String id = "LOGIN";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    try {
      AuthResult user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushNamed(context, Chat.id, arguments: user);
    } catch (e) {
      //print(e.toString());
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("\n${e.message}\n"),
            //content: new Text(""),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Chat"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset("assets/Button-filled-monochrome.png"),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          TextField(
            onChanged: (value) => email = value,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Enter your Email...",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          TextField(
            obscureText: true,
            autocorrect: false,
            onChanged: (value) => password = value,
            decoration: InputDecoration(
              hintText: "Enter your Password...",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          CustomButton(
            text: "Login",
            callback: () async {
              await loginUser();
            },
          )
        ],
      ),
    );
  }
}

class Chat extends StatefulWidget {
  static const String id = "CHAT";

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  //final arg = ModalRoute.of(context).settings.arguments ;

  Future<void> callback({@required AuthResult user}) async {
    if (messageController.text.length > 0) {
      //AuthResult user = ModalRoute.of(context).settings.arguments;
      await _firestore.collection("messages").add({
        "text": messageController.text,
        "from": user.user.email,
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthResult user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
            tag: 'logo',
            child: Image.asset("assets/Button-filled-monochrome.png")),
        title: Text("Admin Chat"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              await _firebaseAuth.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("messages").snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messageList = docs
                      .map((doc) => Message(
                            text: doc.data['text'],
                            from: doc.data['from'],
                            me: user.user.email == doc.data['from'],
                          ))
                      .toList();

                  return ListView(
                      controller: scrollController,
                      children: <Widget>[
                    ...messageList
                  ]);
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        onSubmitted: (value)=> callback(user: user),
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Enter a Message...",
                            border: const OutlineInputBorder(),
                          ))),
                  SendButton(
                    text: "Send",
                    callback: ()=>callback(user: user),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child: Text(text),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;
  final bool me;

  const Message({Key key, this.from, this.text, this.me}) : super(key: key);

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
