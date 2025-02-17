import 'package:chat_app/models/place.dart';
import 'package:chat_app/screens/map_screen.dart';
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          location: widget.place.locationOnMap,
                          isSelecting: false,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 70.0,
                    backgroundImage:
                        NetworkImage(widget.place.locationOnMap.imageUrl),
                  ),
                ),
                Text(
                  widget.place.locationOnMap.formattedAddress,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
