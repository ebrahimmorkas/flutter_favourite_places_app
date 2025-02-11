class LocationOnMap {
  const LocationOnMap({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    required this.imageUrl,
  });

  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String imageUrl;
}
