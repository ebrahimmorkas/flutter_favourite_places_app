import 'package:chat_app/screens/places_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/place.dart';

class PlaceListTile extends StatefulWidget {
  const PlaceListTile({super.key, required this.place});

  final Place place;

  @override
  State<PlaceListTile> createState() => _PlaceListTileState();
}

class _PlaceListTileState extends State<PlaceListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: FileImage(widget.place.image),
          ),
          title: Text(widget.place.placeName),
          subtitle: Text(widget.place.locationOnMap.formattedAddress),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlacesDetailsScreen(place: widget.place),
          ),
        );
      },
    );
  }
}
