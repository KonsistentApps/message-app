import 'package:chat_app/router.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:chat_app/ui/views/startup_view.dart';
import 'package:flutter/material.dart';

import 'locator.dart';

void main() {
  // Register all the models and services before the app starts
  setupLocator();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      onGenerateRoute: generateRoute,
      home: StartUpView(),
    );
  }
}
