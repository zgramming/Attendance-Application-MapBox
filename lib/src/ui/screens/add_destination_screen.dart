// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:global_template/global_template.dart';
// import 'package:provider/provider.dart';

// import '../../providers/maps_provider.dart';

// import './widgets/pick_destination_screen/add_destination_form.dart';

// class AddDestinationScreen extends StatefulWidget {
//   static const String routeNamed = '/add-destination-screen';
//   @override
//   _AddDestinationScreenState createState() => _AddDestinationScreenState();
// }

// class _AddDestinationScreenState extends State<AddDestinationScreen> {
//   final Completer<GoogleMapController> _controller = Completer();

//   final TextEditingController _searchLocationController = TextEditingController();
//   final TextEditingController _nameDestinationController = TextEditingController();

//   double iconSize = 40;

//   @override
//   void dispose() {
//     _searchLocationController.dispose();
//     _nameDestinationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tambah Lokasi'),
//         actions: [
//           InkWell(
//             onTap: () => showModalBottomSheet<dynamic>(
//               context: context,
//               builder: (_) => AddDestinationForm(
//                 nameDestinationController: _nameDestinationController,
//               ),
//             ),
//             child: const Padding(
//               padding: EdgeInsets.only(right: 16.0),
//               child: Icon(
//                 FontAwesomeIcons.check,
//                 size: 18.0,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Selector<MapsProvider, Position>(
//             selector: (_, provider) => provider.currentPosition,
//             builder: (_, position, __) {
//               return GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(position.latitude, position.longitude),
//                   zoom: 20,
//                 ),
//                 onMapCreated: (controller) async {
//                   _controller.complete(controller);
//                   await _gotToCenterUser();
//                 },
//                 onCameraMove: (position) =>
//                     context.read<MapsProvider>().setTrackingCameraPosition(position),
//                 onCameraIdle: () => print('Stop Camera'),
//               );
//             },
//           ),
//           Positioned(
//             child: Icon(
//               FontAwesomeIcons.mapMarkerAlt,
//               color: colorPallete.primaryColor,
//               size: iconSize,
//             ),
//             top: (sizes.height(context) - iconSize - kToolbarHeight) / 2.25,
//             right: (sizes.width(context) - iconSize) / 2,
//           ),
// Align(
//   alignment: Alignment.topCenter,
//   child: Padding(
//     padding: const EdgeInsets.only(top: kToolbarHeight, right: 40, left: 40),
//     child: TextFormFieldCustom(
//       controller: _searchLocationController,
//       onSaved: (value) => print(value),
//       onFieldSubmitted: (value) => _moveCameraByAddress(value),
//       onChanged: _onChangedSearcLocation,
//       prefixIcon: const Icon(
//         FontAwesomeIcons.searchLocation,
//         size: 18,
//       ),
//       suffixIcon: Selector<GlobalProvider, bool>(
//         selector: (_, provider) => provider.isShowClearTextField,
//         builder: (_, showClearTextField, __) {
//           return showClearTextField
//               ? IconButton(
//                   icon: const Icon(FontAwesomeIcons.times),
//                   onPressed: _clearSearchLocation,
//                   iconSize: 18,
//                   color: colorPallete.weekEnd,
//                 )
//               : const SizedBox();
//         },
//       ),
//       textInputAction: TextInputAction.search,
//       hintText: 'Cari Lokasi Absen...',
//       disableOutlineBorder: false,
//       hintStyle: appTheme.caption(context),
//     ),
//   ),
// ),
//         ],
//       ),
//     );
//   }

//   Future<void> _gotToCenterUser() async {
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: LatLng(
//             context.read<MapsProvider>().currentPosition.latitude,
//             context.read<MapsProvider>().currentPosition.longitude,
//           ),
//           zoom: 20,
//         ),
//       ),
//     );
//   }

//   Future<void> _moveCameraByAddress(String address) async {
//     try {
//       final List<Placemark> placemark =
//           await Geolocator().placemarkFromAddress(address.toLowerCase());
//       if (placemark != null) {
//         final GoogleMapController controller = await _controller.future;
//         final Position position = placemark[0].position;
//         await controller
//             .animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
//         print(placemark[0].toJson());
//       } else {
//         throw 'Destinasi Tidak Ditemukan';
//       }
//     } on PlatformException catch (err) {
//       if (err.code == 'ERROR_GEOCODNG_ADDRESSNOTFOUND') {
//         await globalF.showToast(
//             message: 'Destinasi Tidak Ditemukan', isError: true, isLongDuration: true);
//       } else {
//         await globalF.showToast(message: err.code, isError: true, isLongDuration: true);
//       }
//     } catch (e) {
//       await globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
//     }
//   }

//   void _onChangedSearcLocation(String value) {
//     final globalProvider = context.read<GlobalProvider>();
//     if (value.isEmpty) {
//       globalProvider.setShowClearTextField(false);
//     } else {
//       globalProvider.setShowClearTextField(true);
//     }
//   }

//   void _clearSearchLocation() {
//     _searchLocationController.clear();
//     context.read<GlobalProvider>().setShowClearTextField(false);
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
import 'package:provider/provider.dart';
import 'package:latlong/latlong.dart';
import 'pick_destination_screen/add_destination_form.dart';
import '../../providers/maps_provider.dart';

class AddDestinationScreen extends StatefulWidget {
  static const routeNamed = "/add-destination-screen";

  @override
  _AddDestinationScreenState createState() => _AddDestinationScreenState();
}

class _AddDestinationScreenState extends State<AddDestinationScreen> {
  final TextEditingController _searchLocationController = TextEditingController();
  final TextEditingController _nameDestinationController = TextEditingController();
  MapController _mapController;
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _searchLocationController.dispose();
    _nameDestinationController.dispose();
    super.dispose();
  }

  static const double iconSize = 40;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Lokasi'),
        actions: [
          InkWell(
            onTap: () => showModalBottomSheet<dynamic>(
              context: context,
              builder: (_) => AddDestinationForm(
                nameDestinationController: _nameDestinationController,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                FontAwesomeIcons.check,
                size: 18.0,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Selector<MapsProvider, Position>(
            selector: (_, provider) => provider.currentPosition,
            builder: (_, position, __) {
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(position.latitude, position.longitude),
                  zoom: 13.0,
                  onPositionChanged: (mapPositioned, hasGesture) {
                    print("Move Camera ${mapPositioned.center}");
                    Future.delayed(
                        Duration(seconds: 1),
                        () =>
                            context.read<MapsProvider>().setTrackingCameraPosition(mapPositioned));
                  },
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayerOptions(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(51.5, -0.09),
                        builder: (ctx) => Container(
                          child: FlutterLogo(),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          Positioned(
            child: Icon(
              FontAwesomeIcons.mapMarkerAlt,
              color: colorPallete.primaryColor,
              size: iconSize,
            ),
            top: (sizes.height(context) - iconSize - kToolbarHeight) / 2.25,
            right: (sizes.width(context) - iconSize) / 2,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight, right: 40, left: 40),
              child: TextFormFieldCustom(
                controller: _searchLocationController,
                onSaved: (value) => print(value),
                onFieldSubmitted: (value) => _moveCameraByAddress(value),
                onChanged: _onChangedSearcLocation,
                prefixIcon: const Icon(
                  FontAwesomeIcons.searchLocation,
                  size: 18,
                ),
                suffixIcon: Selector<GlobalProvider, bool>(
                  selector: (_, provider) => provider.isShowClearTextField,
                  builder: (_, showClearTextField, __) {
                    return showClearTextField
                        ? IconButton(
                            icon: const Icon(FontAwesomeIcons.times),
                            onPressed: _clearSearchLocation,
                            iconSize: 18,
                            color: colorPallete.weekEnd,
                          )
                        : const SizedBox();
                  },
                ),
                textInputAction: TextInputAction.search,
                hintText: 'Cari Lokasi Absen...',
                disableOutlineBorder: false,
                hintStyle: appTheme.caption(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _moveCameraByAddress(String address) async {
    try {
      final List<Placemark> placemark =
          await Geolocator().placemarkFromAddress(address.toLowerCase());
      if (placemark != null) {
        final Position position = placemark[0].position;
        _mapController.move(LatLng(position.latitude, position.longitude), 18);

        print(placemark[0].toJson());
      } else {
        throw 'Destinasi Tidak Ditemukan';
      }
    } on PlatformException catch (err) {
      if (err.code == 'ERROR_GEOCODNG_ADDRESSNOTFOUND') {
        await globalF.showToast(
            message: 'Destinasi Tidak Ditemukan', isError: true, isLongDuration: true);
      } else {
        await globalF.showToast(message: err.code, isError: true, isLongDuration: true);
      }
    } catch (e) {
      await globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
    }
  }

  void _onChangedSearcLocation(String value) {
    final globalProvider = context.read<GlobalProvider>();
    if (value.isEmpty) {
      globalProvider.setShowClearTextField(false);
    } else {
      globalProvider.setShowClearTextField(true);
    }
  }

  void _clearSearchLocation() {
    _searchLocationController.clear();
    context.read<GlobalProvider>().setShowClearTextField(false);
  }
}
