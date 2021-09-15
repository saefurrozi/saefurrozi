import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Navigation {
  static intentWithData(String routeName, String arguments) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static intentRoute(String routeName) {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  static back() => navigatorKey.currentState?.pop();
}
