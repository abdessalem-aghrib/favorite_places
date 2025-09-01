import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AddPlaceScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: ref.read(userPlacesProvider.notifier).loadPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<Place> places = snapshot.data as List<Place>;

          ref.read(userPlacesProvider.notifier).init(places);

          return Consumer(
            builder: (_, ref, __) {
              final userPlaces = ref.watch(userPlacesProvider);

              return PlacesList(places: userPlaces);
            },
          );
        },
      ),
    );
  }
}
