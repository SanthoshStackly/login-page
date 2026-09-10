import 'package:flutter/material.dart';

import '../landing_page.dart';
import '../login_page.dart';
import '../otp_page.dart';
import '../signup_page.dart';
import '../home_page.dart';

class AppRoutes {
  static const String landing = '/landing';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String signup = '/signup';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    landing: (context) => const LandingPage(),
    login: (context) => const LoginPage(),
    otp: (context) => const OtpPage(),
    signup: (context) => const SignUpPage(),
    home: (context) => const HomePage(),
  };
}
