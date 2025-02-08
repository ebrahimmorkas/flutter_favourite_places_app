import 'package:chat_app/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/providers/place_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  ConsumerState<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends ConsumerState<NewPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredPlaceName = '';

  void _addPlace() {
    if (_formKey.currentState!.validate()) {
      // Form is validated
      _formKey.currentState!.save();
      ref.read(placeProvider.notifier).addPlace(
          Place(id: DateTime.now().toString(), placeName: _enteredPlaceName));
      Navigator.pop(context);
    } else {
      // Form in not validated
      return;
    }
  }

  File? selectedImage;

  void takePicture() async {
    final ImagePicker imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      return;
    }

    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Place"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length <= 5) {
                    return "Must be between 0 to 50 characters";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  setState(() {
                    _enteredPlaceName = newValue!;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                ),
                width: double.infinity,
                height: 250,
                child: selectedImage == null
                    ? ElevatedButton.icon(
                        onPressed: takePicture,
                        label: Text("Take Picture"),
                        icon: Icon(Icons.camera),
                      )
                    : Image.file(
                        selectedImage!,
                        width: double.infinity,
                      ),
                // child: ElevatedButton.icon(
                //   onPressed: () {},
                //   label: Text("Take Picture"),
                //   icon: Icon(Icons.camera),
                // ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _addPlace,
                  label: Text("Add Place"),
                  icon: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
