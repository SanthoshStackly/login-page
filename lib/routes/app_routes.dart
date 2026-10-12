// import 'package:flutter/material.dart';

// import '../screens/welcome.dart';
// import '../screens/login_page.dart';
// import '../screens/signup_page.dart';
// import '../screens/home_page.dart';

// class AppRoutes {
//   // Route names
//   static const String landing = '/landing';
//   static const String login = '/login';
//   static const String signup = '/signup';
//   static const String home = '/home';

//   // Routes
//   static Map<String, WidgetBuilder> routes = {
//     // FIRST SCREEN
//     landing: (context) => const WelcomePage(),

//     // SIGN IN PAGE
//     login: (context) => const LoginPage(),

//     // SIGN UP PAGE
//     signup: (context) => const SignUpPage(),

//     // HOME PAGE
//     home: (context) => const HomePage(),
//   };
// }

import 'package:flutter/material.dart';

import '../screens/welcome.dart';
import '../screens/login_page.dart';
import '../screens/signup_page.dart';
import '../screens/home_page.dart';

class AppRoutes {
  static const String landing = '/landing';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static final Map<String, WidgetBuilder> routes = {
    landing: (context) => const WelcomePage(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignUpPage(),
    home: (context) => const HomePage(),
  };
}
