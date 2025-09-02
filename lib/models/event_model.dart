import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String imageUrl;
  final String createdBy;
  final List<String> tags;
  final List<String> participants; // all attendees
  final List<String> organizers;   // admins/organizers

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.imageUrl,
    required this.createdBy,
    required this.tags,
    required this.participants,
    required this.organizers,
  });

  factory Event.fromMap(Map<String, dynamic> map, String docId) {
    return Event(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      imageUrl: map['imageUrl'] ?? '',
      createdBy: map['createdBy'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      participants: List<String>.from(map['participants'] ?? []),
      organizers: List<String>.from(map['organizers'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'tags': tags,
      'participants': participants,
      'organizers': organizers,
    };
  }
}
