class DeviceLocation {
  double? latitude;
  double? longitude;
  bool gpsEnable = true;
  bool permissionGranted = true;

  DeviceLocation(double? latitude, double? longitude);

  DeviceLocation.gpsEnable(bool gpsEnable);

  DeviceLocation.permissionGranted(bool permissionGranted);
}
