import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
        actions: [
          TextButton.icon(
            onPressed: () async {
              String lat = "${place.location.latitude}";
              String lng = "${place.location.longitude}";

              var uri = Uri.parse("https://www.google.com/maps?q=$lat,$lng");

              if (await canLaunchUrl(uri)) {
                launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
              }
            },
            label: Text('Open In Map'),
            icon: Icon(Icons.map_rounded),
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: place.id,
          child: Image.file(
            place.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
