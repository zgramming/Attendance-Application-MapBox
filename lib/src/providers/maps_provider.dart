import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_template/global_template.dart';
import 'package:mapbox_search/mapbox_search.dart';

class MapsProvider extends ChangeNotifier {
  Position _currentPosition;
  Position get currentPosition => _currentPosition;

  List<MapBoxPlace> _autocompleteMapbox = [];
  List<MapBoxPlace> get autocompleteMapbox => _autocompleteMapbox;

  Future<List<MapBoxPlace>> getAutocompleteMapbox({
    @required String query,
    @required String apiKey,
  }) async {
    try {
      final result = await PlacesSearch(
        apiKey: apiKey,
        country: AppConfig.countryCodeID,
        language: AppConfig.languageID,
        limit: 5,
      ).getPlaces(query);
      _autocompleteMapbox = result;
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getCurrentPosition() async {
    try {
      final Position lastPosition = await Geolocator().getLastKnownPosition();
      if (lastPosition != null) {
        print('Success Get Last Position...');
        _currentPosition = lastPosition;
      } else {
        print('Failed Get Last Position...');
        // TODO(getCurrentPosition): Bug Mendapatkan Current Position
        final currentPosition =
            await Geolocator().getCurrentPosition().timeout(const Duration(seconds: 15));
        if (currentPosition != null) {
          print('Success Get Your Current Position...');
          _currentPosition = currentPosition;
        } else {
          print('Failed Get Your Current Position...');
          throw 'Cant Get Your Position';
        }
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  void setTrackingLocation(Position position) {
    _currentPosition = position;
    notifyListeners();
  }

  MapPosition _cameraPosition;
  MapPosition get cameraPosition => _cameraPosition;

  void setTrackingCameraPosition(MapPosition value) {
    _cameraPosition = value;
    notifyListeners();
  }
}
