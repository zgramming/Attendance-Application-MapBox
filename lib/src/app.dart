import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import './ui/screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Absen OnlineKu",
      theme: ThemeData(
        primaryColor: colorPallete.primaryColor,
        accentColor: colorPallete.accentColor,
        scaffoldBackgroundColor: colorPallete.scaffoldColor,
        cardTheme: const CardTheme(elevation: 3),
        fontFamily: 'VarelaRound',
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
