import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:network/network.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:user_location/user_location.dart';

import '../../function/common_function.dart';
import '../../providers/absen_provider.dart';
import '../../providers/maps_provider.dart';
import '../../providers/user_provider.dart';

import './welcome_screen.dart';
import './widgets/welcome_screen/button_attendance.dart';

class MapScreen extends StatefulWidget {
  static const routeNamed = '/map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // ADD THIS
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;
  // ADD THIS
  List<Marker> markers = [];
  static const double radiusCircle = 6;
  StreamSubscription<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    trackingLocation();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    print('Dispose Stream Listen');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // You can use the userLocationOptions object to change the properties
    // of UserLocationOptions in runtime
    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: markers,
    );
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Selector2<MapsProvider, AbsenProvider, Tuple2<Position, DestinasiModel>>(
            selector: (_, provider1, provider2) =>
                Tuple2(provider1.currentPosition, provider2.destinasiModel),
            builder: (_, value, __) => FlutterMap(
              options: MapOptions(
                center: LatLng(value.item1.latitude, value.item1.longitude),
                zoom: 15.0,
                plugins: [
                  // ADD THIS
                  UserLocationPlugin(),
                ],
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                // ADD THIS
                MarkerLayerOptions(markers: markers),
                CircleLayerOptions(
                  circles: [
                    buildCircleMarker(value),
                  ],
                ),
                // ADD THIS
                userLocationOptions,
              ],
              // ADD THIS
              mapController: mapController,
            ),
          ),
          Positioned(
            bottom: 30,
            left: 10,
            right: 50,
            child: Selector2<MapsProvider, AbsenProvider, Tuple2<Position, DestinasiModel>>(
              selector: (_, provider1, provider2) =>
                  Tuple2(provider1.currentPosition, provider2.destinasiModel),
              builder: (_, value, __) {
                return ButtonAttendance(
                  onTapAbsen: () => _validateAbsen(
                    distanceTwoLocation: commonF.getDistanceLocation(
                      value.item1,
                      value.item2,
                    ),
                    radius: radiusCircle,
                    isAbsentIn: true,
                  ),
                  backgroundColor: Colors.transparent,
                  onTapPulang: () => _validateAbsen(
                    distanceTwoLocation: commonF.getDistanceLocation(
                      value.item1,
                      value.item2,
                    ),
                    radius: radiusCircle,
                    isAbsentIn: false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  CircleMarker buildCircleMarker(Tuple2<Position, DestinasiModel> value) {
    print('DISTANCE LOCATION ${commonF.getDistanceLocation(value.item1, value.item2)}');
    return CircleMarker(
      borderColor: colorPallete.transparent,
      color: commonF
          .changeColorRadius(commonF.getDistanceLocation(value.item1, value.item2), radiusCircle)
          .withOpacity(.6),
      radius: radiusCircle,
      useRadiusInMeter: true,
      point: LatLng(
        value.item2.latitude,
        value.item2.longitude,
      ),
    );
  }

  void trackingLocation() {
    const locationOptions = LocationOptions();
    final Stream<Position> positionStream = Geolocator().getPositionStream(locationOptions);
    _positionStream = positionStream.listen((Position position) {
      context.read<MapsProvider>().setTrackingLocation(position);
      print(
          ' Tracking :Lat=${position.latitude} Long=${position.longitude} Accuracy=${position.accuracy} Speed=${position.speed} Mocked=${position.mocked}');
    }, onError: (dynamic error) => print('Error Handling Listen Stream ${error.toString()}'));
  }

  Future<void> _validateAbsen({
    @required double distanceTwoLocation,
    @required double radius,
    @required bool isAbsentIn,
  }) async {
    final userProvider = context.read<UserProvider>();
    final absenProvider = context.read<AbsenProvider>();
    final globalProvider = context.read<GlobalProvider>();
    final mapsProvider = context.read<MapsProvider>();
    final isInsideRadius = commonF.isInsideRadiusCircle(distanceTwoLocation, radius);

    if (!mapsProvider.currentPosition.mocked) {
      if (isInsideRadius) {
        try {
          globalProvider.setLoading(true);
          final trueTime = await commonF.getTrueTime();
          final timeFormat = DateFormat('HH:mm:ss').format(trueTime);
          String result;
          if (isAbsentIn) {
            result = await absenProvider.absensiMasuk(
              idUser: userProvider.user.idUser,
              tanggalAbsen: trueTime,
              tanggalAbsenMasuk: trueTime,
              jamAbsenMasuk: timeFormat,
              createdDate: trueTime,
            );
          } else {
            result = await absenProvider.absensiPulang(
              idUser: userProvider.user.idUser,
              tanggalAbsenPulang: trueTime,
              jamAbsenPulang: timeFormat,
              updateDate: trueTime,
            );
          }
          await globalF.showToast(message: result, isSuccess: true, isLongDuration: true);
          globalProvider.setLoading(false);
          await Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeNamed);
        } catch (e) {
          await globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
          globalProvider.setLoading(false);
        }
      } else {
        await globalF.showToast(message: 'Anda Diluar Jangkauan Absensi', isError: true);
      }
    } else {
      await globalF.showToast(
        message: 'Mock Location Terdeteksi , Tidak Dapat Melakukan Absen.',
        isError: true,
        isLongDuration: true,
      );
    }
  }
}
