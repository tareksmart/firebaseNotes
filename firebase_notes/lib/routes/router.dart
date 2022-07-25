

import 'package:firebase_notes/home.dart';
import 'package:firebase_notes/routes/routes.dart';
import 'package:flutter/material.dart';

import '../auth/login.dart';
import '../auth/signup.dart';

class speialRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.signup:
        return MaterialPageRoute(builder: (_) => SignUp());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => LogIn());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => MyHomePage());
      default:
        return MaterialPageRoute(builder: (_) => LogIn());
    }
  }
}
