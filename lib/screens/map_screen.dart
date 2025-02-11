import 'package:chat_app/models/location_on_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const LocationOnMap(
      formattedAddress: '',
      imageUrl: '',
      latitude: 18.9830629,
      longitude: 72.8401111,
    ),
    required this.isSelecting,
  });

  final LocationOnMap location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng selectedPosition;

  @override
  void initState() {
    super.initState();
    selectedPosition =
        LatLng(widget.location.latitude, widget.location.longitude);
  }

  void saveLocation() {
    if (selectedPosition == null) {
      return;
    }
    // double latitude = selectedPosition!.latitude;
    // double longitude = selectedPosition!.longitude;
    Navigator.pop(context, selectedPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("map"),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: saveLocation,
              icon: Icon(Icons.save),
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('m1'),
            // position: LatLng(
            //   widget.location.latitude,
            //   widget.location.longitude,
            // ),
            position: selectedPosition,
          ),
        },
        onTap: widget.isSelecting
            ? (position) {
                setState(() {
                  print("inside set state of map screen");
                  selectedPosition = position;
                });
              }
            : null,
      ),
    );
  }
}
