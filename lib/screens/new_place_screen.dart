import 'package:chat_app/models/place.dart';
import 'package:chat_app/widgets/location_input.dart';
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
  String? mapImageUrl;
  void getMapImageUrl(String mapUrl) {
    setState(() {
      mapImageUrl = mapUrl;
    });
  }

  final _formKey = GlobalKey<FormState>();
  String _enteredPlaceName = '';
  File? selectedImage;

  void _addPlace() {
    print("Add place function called");
    if (_formKey.currentState!.validate()) {
      // if (_enteredPlaceName.isNotEmpty) {
      // Form is validated
      _formKey.currentState!.save();
      ref.read(placeProvider.notifier).addPlace(Place(
            id: DateTime.now().toString(),
            placeName: _enteredPlaceName,
            image: selectedImage!,
          ));
      Navigator.pop(context);
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Please select image")),
      //   );
      // }
    } else {
      // Form in not validated
      return;
    }
  }

  void takePicture() async {
    print("Take picture function called");
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
        child: SingleChildScrollView(
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
                InkWell(
                  onTap: takePicture,
                  child: Container(
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
                ),
                const SizedBox(
                  height: 10,
                ),
                LocationInput(
                  mapImageStringUrl: getMapImageUrl,
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
      ),
    );
  }
}
