import 'dart:io';

import 'package:favourite_places/models/places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPlaceNotifier extends StateNotifier<List<Place>> {
  UserPlaceNotifier() : super(const []);

  void addplace(String title, File image, Placelocation location) {
    final newplace = Place(title: title, image: image, location: location);
    state = [newplace, ...state];
  }
}

final userPlaceProvider = StateNotifierProvider<UserPlaceNotifier, List<Place>>(
  (ref) => UserPlaceNotifier(),
);
