import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

import '../../providers/maps_provider.dart';

import './widgets/pick_destination_screen/add_destination_form.dart';
import './widgets/pick_destination_screen/input_text_search_destination.dart';

class AddDestinationScreen extends StatefulWidget {
  static const routeNamed = '/add-destination-screen';

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
                    print('Move Camera ${mapPositioned.center}');
                    Future.delayed(
                      const Duration(seconds: 1),
                      () => context.read<MapsProvider>().setTrackingCameraPosition(mapPositioned),
                    );
                  },
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/zeffryy/ckbm42cwb124f1ipgndrdcz8p/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiemVmZnJ5eSIsImEiOiJja2JtM3hrOWMxZmJ0MnNvZDZ5b3FteXZvIn0.by1MdhnYRjFSDTClAVMNyg',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayerOptions(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(51.5, -0.09),
                        builder: (ctx) => Container(
                          child: const FlutterLogo(),
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
            child: InputTextSearchAddress(
              searchLocationController: _searchLocationController,
              mapController: _mapController,
            ),
          ),
        ],
      ),
    );
  }
}
