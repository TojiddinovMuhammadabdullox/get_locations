import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesson73/controller/travels_controller.dart';
import 'package:lesson73/model/travel.dart';
import 'package:lesson73/services/location_service.dart';

class NewLocationScreen extends StatefulWidget {
  final Travel? travel;

  const NewLocationScreen({super.key, this.travel});

  @override
  State<NewLocationScreen> createState() => _NewLocationScreenState();
}

class _NewLocationScreenState extends State<NewLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final _travelsController = TravelsController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String? cityName;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
    if (widget.travel != null) {
      titleController.text = widget.travel!.title;
      descriptionController.text = widget.travel!.description;
      cityName = widget.travel!.location;
    }
  }

  Future<void> _fetchCurrentLocation() async {
    await LocationService.init();
    await LocationService.getCurrentLocation();
    final currentLocation = LocationService.currentLocation;
    if (currentLocation != null) {
      double lat = currentLocation.latitude!;
      double lang = currentLocation.latitude!;
      cityName = await LocationService.getCityFromCoordinates(lang, lang);
      setState(() {});
    }
  }

  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (widget.travel != null) {
        // Update existing travel
        await _travelsController.updateTravel(
          widget.travel!.id,
          titleController.text,
          descriptionController.text,
          _image,
          cityName ?? "",
        );
      } else {
        // Add new travel
        await _travelsController.addTravels(
          titleController.text,
          descriptionController.text,
          _image!,
          cityName ?? "",
        );
      }
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text("Camera"),
            onTap: () async {
              final file = await picker.pickImage(source: ImageSource.camera);
              Navigator.pop(context, file);
            },
          ),
          ListTile(
            leading: const Icon(Icons.image_outlined),
            title: const Text("Gallery"),
            onTap: () async {
              final file = await picker.pickImage(source: ImageSource.gallery);
              Navigator.pop(context, file);
            },
          )
        ],
      ),
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber,
        title: const Text(
          "Add Location",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : widget.travel != null &&
                                  widget.travel!.imageUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(widget.travel!.imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    child: _image == null && widget.travel == null
                        ? const Icon(
                            Icons.add_a_photo_outlined,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: titleController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: "Place name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a place name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _validateAndSubmit,
                      child: Text(
                        widget.travel != null ? "Update" : "Save",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
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
