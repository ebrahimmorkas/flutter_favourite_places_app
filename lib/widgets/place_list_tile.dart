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
      child: ListTile(
        title: Text(widget.place.placeName),
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
