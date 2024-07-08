import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class LocationService {
  static final loc.Location _location = loc.Location();

  static bool _isServiceEnabled = false;
  static loc.PermissionStatus _permissionStatus = loc.PermissionStatus.denied;
  static loc.LocationData? currentLocation;

  static Future<void> init() async {
    await _checkService();
    await _checkPermission();

    await _location.changeSettings(
      accuracy: loc.LocationAccuracy.high,
      distanceFilter: 10,
      interval: 1000,
    );
  }

  static Future<void> _checkService() async {
    _isServiceEnabled = await _location.serviceEnabled();

    if (!_isServiceEnabled) {
      _isServiceEnabled = await _location.requestService();
      if (!_isServiceEnabled) {
        return; // Redirect to Settings - Sozlamalardan to'g'irlash kerak endi
      }
    }
  }

  static Future<void> _checkPermission() async {
    _permissionStatus = await _location.hasPermission();

    if (_permissionStatus == loc.PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
      if (_permissionStatus != loc.PermissionStatus.granted) {
        return; // Sozlamalardan to'g'irlash kerak (ruxsat berish kerak)
      }
    }
  }

  static Future<void> getCurrentLocation() async {
    if (_isServiceEnabled &&
        _permissionStatus == loc.PermissionStatus.granted) {
      currentLocation = await _location.getLocation();
    }
  }

  static Future<String> getCityFromCoordinates(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark placemark = placemarks.first;
    return placemark.locality ??
        ''; // Return city name or empty string if not available
  }

  static Stream<loc.LocationData> getLiveLocation() {
    return _location.onLocationChanged;
  }
}
