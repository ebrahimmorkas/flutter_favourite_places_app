import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool isGettingLocation = false;
  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();

    setState(() {
      isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          width: double.infinity,
          height: 250,
          child: isGettingLocation
              ? CircularProgressIndicator()
              : Text("No location selected"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getCurrentLocation,
              label: Text("Get Current Location"),
              icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: () {},
              label: Text("Select on map"),
              icon: Icon(Icons.map),
            ),
          ],
        )
      ],
    );
  }
}
