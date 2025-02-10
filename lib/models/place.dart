import 'dart:io';

import 'package:chat_app/models/location_on_map.dart';

class Place {
  Place(
      {required this.id,
      required this.placeName,
      required this.image,
      required this.locationOnMap});
  String id;
  String placeName;
  File image;
  LocationOnMap locationOnMap;
}
