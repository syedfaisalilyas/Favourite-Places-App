import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:favourite_places/models/places.dart';
import 'package:favourite_places/screens/place_detail.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({Key? key, required this.placesList}) : super(key: key);
  final List<Place> placesList;

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  Future<String> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return place.name ?? place.thoroughfare ?? '';
      }
    } catch (e) {
      print('Error getting address: $e');
    }
    return 'Address not found';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.placesList.isEmpty) {
      return Center(
        child: Text(
          'Nothing to show rn!',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.placesList.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: Key(widget.placesList[index].title),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onDismissed: (direction) {
          setState(() {
            widget.placesList.remove(widget.placesList[index]);
          });
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: FileImage(widget.placesList[index].image),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                widget.placesList.remove(widget.placesList[index]);
              });
            },
          ),
          title: Text(
            widget.placesList[index].title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          subtitle: FutureBuilder<String>(
            future: getAddress(
              widget.placesList[index].location.latitude,
              widget.placesList[index].location.longitude,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading address...');
              } else if (snapshot.hasError) {
                return Text('Error getting address');
              } else {
                return Text(snapshot.data ?? '');
              }
            },
          ),
          onTap: () async {
            String address = await getAddress(
              widget.placesList[index].location.latitude,
              widget.placesList[index].location.longitude,
            );

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => PlaceDetails(
                  place: widget.placesList[index],
                  address: address,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
