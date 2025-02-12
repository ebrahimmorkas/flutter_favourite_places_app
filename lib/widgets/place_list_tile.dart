import 'package:chat_app/screens/places_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/providers/place_provider.dart';

class PlaceListTile extends ConsumerStatefulWidget {
  const PlaceListTile({super.key, required this.place});

  final Place place;

  @override
  ConsumerState<PlaceListTile> createState() => _PlaceListTileState();
}

class _PlaceListTileState extends ConsumerState<PlaceListTile> {
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
          trailing: InkWell(
            onTap: () {
              // print("Delete button clicked");
              ref.read(placeProvider.notifier).delete(widget.place.id);
            },
            child: Icon(
              Icons.delete,
            ),
          ),
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
