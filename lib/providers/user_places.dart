import 'dart:developer';
import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sqflite/sqflite.dart' as sqflite;

Future<sqflite.Database> getDatabase() async {
  final dbPath = await sqflite.getDatabasesPath();
  final db = await sqflite.openDatabase(
    path.join(dbPath, "places.db"),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE user_places (id TEXT PRIMARY KEY , title TEXT, image TEXT, latitude REAL , longitude REAL)",
      );
    },
    version: 1,
  );

  return db;
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
    );

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super([]);

  init(List<Place> places) {
    state.clear();

    state.addAll(places);
  }

  Future<List<Place>> loadPlaces() async {
    var db = await getDatabase();
    var data = await db.query("user_places");
    List<Place> places = data
        .map(
          (row) => Place(
            id: row["id"] as String,
            title: row["title"] as String,
            image: File(row["image"] as String),
            location: PlaceLocation(
              latitude: row["latitude"] as double,
              longitude: row["longitude"] as double,
            ),
          ),
        )
        .toList();

    return places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    try {
      // store the picture on the application directory
      final Directory appDirectory = await path_provider
          .getApplicationDocumentsDirectory();
      final imageName = path.basename(image.path);
      final copiedImage = await image.copy("${appDirectory.path}/$imageName");

      // store the place on the database

      final newPlace = Place(
        title: title,
        image: copiedImage,
        location: location,
      );

      var db = await getDatabase();
      int value = await db.insert("user_places", {
        "id": newPlace.id,
        "title": newPlace.title,
        "image": newPlace.image.path,
        "latitude": newPlace.location.latitude,
        "longitude": newPlace.location.longitude,
      });
      log("value : $value");

      state = [newPlace, ...state];
    } catch (error) {
      log(error.toString());
    }
  }
}
