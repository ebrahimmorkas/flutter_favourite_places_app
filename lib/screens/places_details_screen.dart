import 'package:chat_app/models/place.dart';
import 'package:flutter/material.dart';

class PlacesDetailsScreen extends StatefulWidget {
  const PlacesDetailsScreen({super.key, required this.place});

  final Place place;

  @override
  State<PlacesDetailsScreen> createState() => _PlacesDetailsScreenState();
}

class _PlacesDetailsScreenState extends State<PlacesDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.placeName),
      ),
      body: Stack(
        children: [
          Image.file(
            widget.place.image,
            width: double.infinity,
            height: double.infinity,
          ),
        ],
      ),
    );
  }
}
