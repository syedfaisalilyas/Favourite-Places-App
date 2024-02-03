import 'dart:convert';
import 'package:favourite_places/models/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  LocationInput({Key? key, required this.nlocation}) : super(key: key);

  final void Function(Placelocation location) nlocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  GoogleMapController? controller;
  Placelocation? _locationData;
  var isGettingLocation = false;

  void onMapCreated(GoogleMapController ctr) {
    controller = ctr;
  }

  void navigateToMapScreen() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext sheetContext) {
        return Container(
          height: 300,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Select Location'),
            ),
            body: GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: _locationData != null
                  ? CameraPosition(
                      target: LatLng(
                        _locationData!.latitude!,
                        _locationData!.longitude!,
                      ),
                      zoom: 15.0,
                    )
                  : const CameraPosition(target: LatLng(0, 0), zoom: 11.0),
              onTap: (LatLng latLng) {
                setState(() {
                  _locationData = Placelocation(
                    latitude: latLng.latitude,
                    longitude: latLng.longitude,
                  );
                  widget.nlocation(_locationData!);
                });
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _getLocation() async {
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

    try {
      locationData = await location.getLocation();
      if (locationData == null ||
          locationData.latitude == null ||
          locationData.longitude == null) {
        return;
      }
      setState(() {
        _locationData = Placelocation(
          latitude: locationData.latitude ?? 0.0,
          longitude: locationData.longitude ?? 0.0,
        );
        isGettingLocation = false;
      });
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        isGettingLocation = false;
      });
    }
    widget.nlocation(_locationData!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewCurrentLocation = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyText1!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );

    if (_locationData != null) {
      previewCurrentLocation = GoogleMap(
        onMapCreated: onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
          zoom: 15.0,
        ),
      );
    }

    if (isGettingLocation) {
      previewCurrentLocation = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          width: double.infinity,
          child: previewCurrentLocation,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get current location'),
            ),
            TextButton.icon(
              onPressed: navigateToMapScreen,
              icon: const Icon(Icons.map),
              label: const Text('Select on map'),
            ),
          ],
        )
      ],
    );
  }
}
