import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventService {
  final CollectionReference _eventCollection =
      FirebaseFirestore.instance.collection('events');

  // Create Event
  Future<void> createEvent(Event event) async {
    await _eventCollection.add(event.toMap());
  }

  // Fetch All Events
  Stream<List<Event>> getEvents() {
    return _eventCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Fetch Single Event
  Future<Event?> getEventById(String eventId) async {
    final doc = await _eventCollection.doc(eventId).get();
    if (doc.exists) {
      return Event.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Update Event
  Future<void> updateEvent(String eventId, Map<String, dynamic> data) async {
    await _eventCollection.doc(eventId).update(data);
  }

  // Delete Event
  Future<void> deleteEvent(String eventId) async {
    await _eventCollection.doc(eventId).delete();
  }

  // --- Participants ---

  Future<void> addParticipant(String eventId, String userId) async {
    await _eventCollection.doc(eventId).update({
      'participants': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> removeParticipant(String eventId, String userId) async {
    await _eventCollection.doc(eventId).update({
      'participants': FieldValue.arrayRemove([userId]),
    });
  }

  // --- Organizers/Admins ---

  Future<void> addOrganizer(String eventId, String userId) async {
    await _eventCollection.doc(eventId).update({
      'organizers': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> removeOrganizer(String eventId, String userId) async {
    await _eventCollection.doc(eventId).update({
      'organizers': FieldValue.arrayRemove([userId]),
    });
  }
}
