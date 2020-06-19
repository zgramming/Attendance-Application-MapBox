import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';

import '../../function/common_function.dart';
import '../screens/widgets/drawer/drawer_custom.dart';
import './widgets/welcome_screen/button_attendance.dart';
import './widgets/welcome_screen/animated_table_calendar.dart';
import './widgets/welcome_screen/card_overall_monthly.dart';
import './widgets/welcome_screen/fab.dart';
import './widgets/welcome_screen/user_profile.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = "/welcome-screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      commonF.getGeolocationPermission().then((locationPermission) {
        if (locationPermission != GeolocationStatus.granted) {
          showDialog(context: context, child: commonF.showPermissionLocation());
        } else {
          commonF.getGPSService().then((gpsPermission) {
            if (!gpsPermission) {
              showDialog(context: context, child: commonF.showPermissionGPS());
            } else {
              print('Permission Success');
            }
          });
        }
      });
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      commonF.initClosePermission(context);
    } else if (state == AppLifecycleState.resumed) {
      commonF.initPermission(context);
    }
  }

  @override
  void dispose() {
    // _buttonAbsentController.dispose();
    // _appbarController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustom(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: kToolbarHeight * 1.5),
                UserProfile(),
                CardOverallMonthly(),
                AnimatedCalendarAndTable(),
                const SizedBox(height: kToolbarHeight * 2),
              ],
            ),
          ),
          Positioned(
            left: 10,
            right: 60,
            bottom: 10,
            child: ButtonAttendance(),
          ),
        ],
      ),
      floatingActionButton: FabChangeMode(),
    );
  }
}
