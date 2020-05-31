import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeNamed = "/welcome-screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => context.read<UserProvider>().removeSessionUser(),
          )
        ],
      ),
      body: Container(),
    );
  }
}
