import 'dart:io';
import 'package:favourite_places/models/places.dart';
import 'package:favourite_places/providers/user_places.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:favourite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Add_place extends ConsumerStatefulWidget {
  const Add_place({super.key});
  @override
  ConsumerState<Add_place> createState() {
    return _Add_place_state();
  }
}

class _Add_place_state extends ConsumerState<Add_place> {
  final _titlecontroller = TextEditingController();
  Placelocation? selectedlocation;
  File? _selectedimage;
  void savadata() {
    final enteredtitle = _titlecontroller.text;
    if (enteredtitle.isEmpty ||
        _selectedimage == null ||
        selectedlocation == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Invalid Data"),
            content: const Text("Please enter a valid title."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }
    ref
        .read(userPlaceProvider.notifier)
        .addplace(enteredtitle, _selectedimage!, selectedlocation!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place!'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Title",
              ),
              controller: _titlecontroller,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 10,
            ),
            ImageInput(onpickimage: (image) {
              _selectedimage = image;
            }),
            const SizedBox(
              height: 10,
            ),
            LocationInput(nlocation: (location) {
              selectedlocation = location;
            }),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              onPressed: () {
                savadata();
              },
              icon: const Icon(Icons.add),
              label: const Text(
                "Add title",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
