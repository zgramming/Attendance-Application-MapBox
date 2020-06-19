import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';

import './src/app.dart';
import './src/providers/user_provider.dart';
import './src/providers/absen_provider.dart';
import './src/providers/maps_provider.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalProvider>(
          create: (_) => GlobalProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<MapsProvider>(
          create: (_) => MapsProvider(),
        ),
        ChangeNotifierProvider<AbsenProvider>(
          create: (_) => AbsenProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}
