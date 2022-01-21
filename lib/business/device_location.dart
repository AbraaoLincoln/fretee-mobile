import 'dart:developer';

import 'package:fretee_mobile/business/usuario.dart';
import 'package:location/location.dart';

class DeviceLocation {
  double? latitude;
  double? longitude;
  bool gpsEnable = true;
  bool permissionGranted = true;

  DeviceLocation();

  // DeviceLocation(double? latitude, double? longitude);

  DeviceLocation.gpsEnable(bool gpsEnable);

  DeviceLocation.permissionGranted(bool permissionGranted);

  static Future<void> getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Usuario.logado.location = DeviceLocation.gpsEnable(false);
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Usuario.logado.location = DeviceLocation.permissionGranted(false);
      }
    }

    _locationData = await location.getLocation();

    Usuario.logado.location = DeviceLocation();
    Usuario.logado.location.latitude = _locationData.latitude;
    Usuario.logado.location.longitude = _locationData.longitude;
  }
}
