import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';

import './src/app.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalProvider>(
          create: (_) => GlobalProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}
