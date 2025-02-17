import 'package:chat_app/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class LocationInput extends StatefulWidget {
  final Function(double, double, String, String) mapImageStringUrl;
  const LocationInput({super.key, required this.mapImageStringUrl});
  // const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool isGettingLocation = false;
  bool isLocationFetched = false;
  bool isSelectingMap = false;
  String? mapImageUrl;

  // This variable will contain the latitude and longitude that will be returned when someone manually selects the location by clicking on button names 'select on map'.
  LatLng? position;

  void getCurrentLocation(bool isFunctionCalled) async {
    // print("Location function called");
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

    // print("Getting location is true");

    // This two variables will store the latitude and longitude that can be either by getting the location automatically or it can be by selecting the position manually
    double? latitude;
    double? longitude;

    if (isFunctionCalled) {
      // print("true");
      if (position == null) {
        return;
      }
      setState(() {
        latitude = position!.latitude;
        longitude = position!.longitude;
      });
    } else {
      // print("false");
      locationData = await location.getLocation();
      setState(() {
        latitude = locationData.latitude!;
        longitude = locationData.longitude!;
      });
    }
    setState(() {
      // print("Set State called");
      // print(latitude);
      // print(longitude);

      // URL to get the image of the map that shows the exact location
      mapImageUrl =
          'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude,CA&zoom=16&size=400x400&key=${dotenv.env['GOOGLE_MAP_API_KEY']}';
      // print(mapImageUrl);
    });

    // Getting the exact location from google map API
    try {
      // print("Inside try block");
      var url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${dotenv.env['GOOGLE_MAP_API_KEY']}');
      // 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${dotenv.env['GOOGLE_MAP_API_KEY']}&language=en');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Response is fetched properly
        Map<String, dynamic> data = jsonDecode(response.body);

        String formattedAddress = data['results'][0]['formatted_address'];
        // print(formattedAddress);

        widget.mapImageStringUrl(
            latitude!, longitude!, formattedAddress, mapImageUrl!);

        setState(() {
          isGettingLocation = false;
          isLocationFetched = true;
        });
      } else {
        // Some problem
        return;
      }
    } catch (error) {
      // Catch block
      // print("Error has been made");
      // print(error);
    }

    // print("Getting Location false");
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
              ? isLocationFetched
                  ? Image.network(mapImageUrl!)
                  : CircularProgressIndicator()
              : isLocationFetched
                  ? Image.network(mapImageUrl!)
                  : Text("No location selected",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 10, 102, 177),
                      )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () {
                getCurrentLocation(false);
              },
              label: Text("Get Current Location"),
              icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: () async {
                LatLng returnedPosition = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(isSelecting: true),
                  ),
                );
                setState(() {
                  position = returnedPosition;
                });

                getCurrentLocation(true);
              },
              label: Text("Select on map"),
              icon: Icon(Icons.map),
            ),
          ],
        )
      ],
    );
  }
}
