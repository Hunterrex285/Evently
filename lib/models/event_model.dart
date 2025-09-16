import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String link;
  final String? bannerUrl;
  final List<String> organizers;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.link,
    this.bannerUrl,
    this.organizers = const [],
  });

  factory Event.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      link: data['link'] ?? '',
      bannerUrl: data['bannerUrl'],
      organizers: List<String>.from(data['organizers'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "startTime": startTime,
      "endTime": endTime,
      "link": link,
      "bannerUrl": bannerUrl,
      "organizers": organizers,
    };
  }
}
