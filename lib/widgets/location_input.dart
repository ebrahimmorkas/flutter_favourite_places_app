import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool isGettingLocation = false;
  void getCurrentLocation() async {
    print("Location function called");
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

    print("Getting location is true");

    locationData = await location.getLocation();
    double latitude = locationData.latitude!;
    double longitude = locationData.longitude!;

    // Getting the exact location from google map API
    try {
      print("Inside try block");
      var url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${dotenv.env['GOOGLE_MAP_API_KEY']}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Response is fetched properly
        Map<String, dynamic> data = jsonDecode(response.body);

        String formattedAddress = data['results'][0]['formatted_address'];
        print(formattedAddress);
      } else {
        // Some problem
        return;
      }
    } catch (error) {
      // Catch block
      print("Error has been made");
      print(error);
    }

    setState(() {
      isGettingLocation = false;
    });

    print("Getting Location false");
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
