import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:global_template/global_template.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:provider/provider.dart';

import '../../../../providers/maps_provider.dart';

class InputTextSearchAddress extends StatelessWidget {
  const InputTextSearchAddress({
    @required this.mapController,
    @required this.searchLocationController,
  });

  final TextEditingController searchLocationController;
  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight, right: 40, left: 40),
      child: Material(
        elevation: 10.0,
        child: TypeAheadFormField<MapBoxPlace>(
          suggestionsCallback: (pattern) async {
            final globalProvider = context.read<GlobalProvider>();
            if (pattern.isEmpty) {
              Future.delayed(const Duration(milliseconds: 500),
                  () => globalProvider.setShowClearTextField(false));
              return [];
            } else {
              Future.delayed(const Duration(milliseconds: 500),
                  () => globalProvider.setShowClearTextField(true));
              return await context
                  .read<MapsProvider>()
                  .getAutocompleteMapbox(query: pattern, apiKey: AppConfig.mapBoxApiKey);
            }
          },
          itemBuilder: (context, itemData) {
            return ListTile(
              leading: const Icon(FontAwesomeIcons.marker),
              title: Text(itemData.placeName),
            );
          },
          onSuggestionSelected: (suggestion) async =>
              await _moveCameraByAddress(suggestion.placeName),
          errorBuilder: (context, error) {
            return Center(child: Text(error.toString()));
          },
          noItemsFoundBuilder: (context) {
            return const Text('Lokasi Tidak Ditemukan');
          },
          hideOnError: true,
          textFieldConfiguration: TextFieldConfiguration(
            controller: searchLocationController,
            decoration: InputDecoration(
              hintStyle: appTheme.caption(context),
              hintText: 'Cari Lokasi Absen',
              filled: true,
              fillColor: colorPallete.white,
              border: InputBorder.none,
              prefixIcon: const Icon(FontAwesomeIcons.searchLocation, size: 18),
              suffixIcon: Selector<GlobalProvider, bool>(
                selector: (_, provider) => provider.isShowClearTextField,
                builder: (_, showClearTextField, __) {
                  if (showClearTextField) {
                    return IconButton(
                      icon: const Icon(FontAwesomeIcons.times),
                      onPressed: () => _clearSearchLocation(context),
                      iconSize: 18,
                      color: colorPallete.weekEnd,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _moveCameraByAddress(String address) async {
    try {
      final List<Placemark> placemark =
          await Geolocator().placemarkFromAddress(address.toLowerCase());
      if (placemark != null) {
        for (final item in placemark) {
          mapController.move(LatLng(item.position.latitude, item.position.longitude), 18);
        }
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

  void _clearSearchLocation(BuildContext context) {
    searchLocationController.clear();
    context.read<GlobalProvider>().setShowClearTextField(false);
  }
}
