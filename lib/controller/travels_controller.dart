import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lesson73/services/travels_firebase_service.dart';

class TravelsController {
  final _travelsFirebaseService = TravelsFirebaseService();

  Stream<QuerySnapshot> get list async* {
    yield* _travelsFirebaseService.getTravels();
  }

  Future<void> addTravels(
    String title,
    String description,
    File imageFile,
    String location,
  ) async {
    await _travelsFirebaseService.addTravels(
      title,
      description,
      imageFile,
      location,
    );
  }

  Future<void> updateTravel(
    String id,
    String title,
    String description,
    File? imageFile,
    String location,
  ) async {
    await _travelsFirebaseService.updateTravel(
      id,
      title,
      description,
      imageFile,
      location,
    );
  }

  Future<void> deleteTravel(String id) async {
    await _travelsFirebaseService.deleteTravel(id);
  }
}
