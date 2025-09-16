import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/models/participants_model.dart';
import '../models/event_model.dart';

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch events (last 1 month cap)
  Stream<List<Event>> getAllEvents() {
    final oneMonthAgo = DateTime.now().subtract(const Duration(days: 30));

    return _db
        .collection("events")
        .where("endTime", isGreaterThanOrEqualTo: oneMonthAgo)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Event.fromDoc(doc)).toList());
  }

  /// Register user into event participants subcollection
  Future<void> registerUser(String eventId, Participant participant) async {
    await _db
        .collection("events")
        .doc(eventId)
        .collection("participants")
        .doc(participant.uid)
        .set(participant.toMap());
  }

  /// Fetch all participants for a given event
  Stream<List<Participant>> getParticipants(String eventId) {
    return _db
        .collection("events")
        .doc(eventId)
        .collection("participants")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Participant.fromMap(doc.data())).toList());
  }

  /// Add an organizer
  Future<void> addOrganizer(String eventId, String userId) async {
    await _db.collection("events").doc(eventId).update({
      "organizers": FieldValue.arrayUnion([userId])
    });
  }
}
