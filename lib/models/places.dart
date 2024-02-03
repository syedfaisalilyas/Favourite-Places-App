import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({required this.title, required this.image, required this.location})
      : id = uuid.v4();
  final String id;
  final File image;
  final String title;
  final Placelocation location;
}

class Placelocation {
  Placelocation({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;
}
