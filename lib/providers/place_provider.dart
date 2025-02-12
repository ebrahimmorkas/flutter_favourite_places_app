import 'package:chat_app/models/location_on_map.dart';
import 'package:chat_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'dart:io';

class PlaceProvider extends StateNotifier<List<Place>> {
  PlaceProvider() : super([]);

// Function that will open the database amd will return the database object
  Future<Database> openDatabase() async {
    var db = await sql.openDatabase(
      'places.db',
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, placeName TEXT, image TEXT, latitude REAL, longitude REAL, formattedAddress TEXT, imageUrl TEXT)');
      },
      version: 1,
    );

    return db;
  }

  // Function that will load the data from system's database
  void loadData() async {
    var db = await openDatabase();

    final data = await db.query('user_places');

    final places = data.map(
      (row) {
        return Place(
          id: row['id'] as String,
          placeName: row['placeName'] as String,
          image: File(row['image'] as String),
          locationOnMap: LocationOnMap(
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            formattedAddress: row['formattedAddress'] as String,
            imageUrl: row['imageUrl'] as String,
          ),
        );
      },
    ).toList();

    state = places;
  }

// Function that will delete the data from device
  Future<int> delete(String id) async {
    state = state.where((element) {
      return element.id != id;
    }).toList();
    final db = await openDatabase();
    final int isDeleted =
        await db.delete('user_places', where: 'id = ?', whereArgs: [id]);
    if (isDeleted == 1) {
      print("Deleted");
      return 1;
    } else {
      print("Not deleted");
      return 0;
    }
  }

// Function that will add the place in memory as well as state
  void addPlace(Place place) async {
    // this line gets the path in which system was storing the data normally
    final appDir = await path_provider.getApplicationDocumentsDirectory();

    final fileName = path.basename(place.image.path);

    // We are copying image to permanently store it in some path or directory
    final copiedImage = await place.image.copy('${appDir.path}/$fileName');

    // Stroing the data in sqllite database

    // Opening the database
    var db = await openDatabase();

    // Stroring in table
    db.insert('user_places', {
      'id': place.id,
      'placeName': place.placeName,
      'image': copiedImage.path,
      'latitude': place.locationOnMap.latitude,
      'longitude': place.locationOnMap.longitude,
      'formattedAddress': place.locationOnMap.formattedAddress,
      'imageUrl': place.locationOnMap.imageUrl,
    });

    state = [
      ...state,
      Place(
          id: place.id,
          image: copiedImage,
          locationOnMap: place.locationOnMap,
          placeName: place.placeName)
    ];
  }
}

final placeProvider = StateNotifierProvider<PlaceProvider, List<Place>>((ref) {
  return PlaceProvider();
});
