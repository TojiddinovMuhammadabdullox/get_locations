import 'package:cloud_firestore/cloud_firestore.dart';

class Travel {
  String id;
  String title;
  String description;
  String imageUrl;
  String location;

  Travel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
  });

  factory Travel.fromQuerySnapshot(QueryDocumentSnapshot query) {
    return Travel(
      id: query.id,
      title: query['title'],
      description: query['description'],
      imageUrl: query['imageUrl'],
      location: query['location'],
    );
  }
}
