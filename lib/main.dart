// import 'package:flutter/material.dart';

// import 'app_theme.dart';
// import 'routes/app_routes.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OneCloud Enterprise Platform',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       initialRoute: AppRoutes.landing,
//       routes: AppRoutes.routes,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'routes/app_routes.dart';
import 'providers/dashboard_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider(),
      child: MaterialApp(
        title: 'OneCloud Enterprise Platform',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: AppRoutes.landing,
        routes: AppRoutes.routes,
      ),
    );
  }
}
