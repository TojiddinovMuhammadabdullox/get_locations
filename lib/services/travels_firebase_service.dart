import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TravelsFirebaseService {
  final _travelCollection = FirebaseFirestore.instance.collection("travels");
  final _imageOfPlaces = FirebaseStorage.instance;

  Stream<QuerySnapshot> getTravels() async* {
    yield* _travelCollection.snapshots();
  }

  Future<void> addTravels(
    String title,
    String description,
    File imageFile,
    String location,
  ) async {
    final imageReference = _imageOfPlaces
        .ref()
        .child('places')
        .child('images')
        .child('$title.jpg');

    final uploadTask = imageReference.putFile(imageFile);

    await uploadTask.whenComplete(() async {
      final imageUrl = await imageReference.getDownloadURL();
      await _travelCollection.add({
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
        "location": location,
      });
    });
  }

  Future<void> updateTravel(
    String id,
    String title,
    String description,
    File? imageFile,
    String location,
  ) async {
    final travelDoc = _travelCollection.doc(id);
    Map<String, dynamic> data = {
      "title": title,
      "description": description,
      "location": location,
    };

    if (imageFile != null) {
      final imageReference = _imageOfPlaces
          .ref()
          .child('places')
          .child('images')
          .child('$title.jpg');

      final uploadTask = imageReference.putFile(imageFile);
      await uploadTask.whenComplete(() async {
        final imageUrl = await imageReference.getDownloadURL();
        data['imageUrl'] = imageUrl;
      });
    }

    await travelDoc.update(data);
  }

  Future<void> deleteTravel(String id) async {
    final travelDoc = _travelCollection.doc(id);
    await travelDoc.delete();
  }
}
