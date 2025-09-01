import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function(PlaceLocation) onLocationPicked;

  const LocationInput({required this.onLocationPicked, super.key});

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  bool _isGettingLocation = false;
  PlaceLocation placeLocation = PlaceLocation(latitude: 0, longitude: 0);

  void _getCurrentLocation() async {
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
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    setState(() {
      _isGettingLocation = false;
    });

    placeLocation = PlaceLocation(
      latitude: double.tryParse(locationData.latitude.toString()) ?? 0,
      longitude: double.tryParse(locationData.longitude.toString()) ?? 0,
    );

    widget.onLocationPicked(placeLocation);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    } else {
      previewContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Text(
            'Long : ${placeLocation.longitude}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'Lat : ${placeLocation.latitude}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
              onPressed: _getCurrentLocation,
            ),
            // TextButton.icon(
            //   icon: const Icon(Icons.map),
            //   label: const Text('Select on Map'),
            //   onPressed: () {},
            // ),
          ],
        ),
      ],
    );
  }
}
