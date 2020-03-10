import 'package:chat_app/ui/views/chat/messages_view.dart';
import 'package:chat_app/ui/views/chat/select_discussion_view.dart';
import 'package:chat_app/ui/views/login/login_view.dart';
import 'package:chat_app/ui/views/login/signup_view.dart';
import 'package:flutter/material.dart';

import 'constants/route_names.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );

    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );

    case SelectDiscussionRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SelectDiscussionView(),
      );

    case MessagesRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: MessagesView(
          arguments: settings.arguments,
        ),
      );

    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return _FadeRoute(child: viewToShow, routeName: routeName);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;

  _FadeRoute({this.child, this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
