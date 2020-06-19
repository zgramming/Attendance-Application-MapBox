import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import './ui/screens/add_destination_screen.dart';
import './ui/screens/login_screen.dart';
import './ui/screens/map_screen.dart';
import './ui/screens/pick_destination_screen.dart';
import './ui/screens/splash_screen.dart';
import './ui/screens/user_profil_screen.dart';
import './ui/screens/welcome_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absen Online MapBox',
      theme: ThemeData(
        primaryColor: colorPallete.primaryColor,
        accentColor: colorPallete.accentColor,
        scaffoldBackgroundColor: colorPallete.scaffoldColor,
        cardTheme: const CardTheme(elevation: 3),
        fontFamily: 'VarelaRound',
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        WelcomeScreen.routeNamed: (context) => WelcomeScreen(),
        LoginScreen.routeNamed: (context) => LoginScreen(),
        MapScreen.routeNamed: (context) => MapScreen(),
        UserProfilScreen.routeNamed: (BuildContext context) => UserProfilScreen(),
        AddDestinationScreen.routeNamed: (BuildContext context) => AddDestinationScreen(),
        PickDestinationScreen.routeNamed: (BuildContext context) => PickDestinationScreen(),
      },
    );
  }
}
