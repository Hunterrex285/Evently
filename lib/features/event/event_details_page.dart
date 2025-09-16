import 'package:evently/models/event_model.dart';
import 'package:evently/models/participants_model.dart';
import 'package:evently/services/event_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;
  final EventService _eventService = EventService();

  EventDetailsPage({super.key, required this.event});

  Future<void> _launchLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _registerUser(BuildContext context) async {
    // Mock participant (replace with actual user data from auth)
    final user = FirebaseAuth.instance.currentUser;
    final participant = Participant(
      uid: user!.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );

    await _eventService.registerUser(event.id, participant);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Successfully registered!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    String status;
    if (event.startTime.isAfter(now)) {
      status = "Upcoming";
    } else if (event.endTime.isBefore(now)) {
      status = "Expired";
    } else {
      status = "Live";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text("Start: ${event.startTime}"),
            Text("End: ${event.endTime}"),
            const SizedBox(height: 16),
            Text("Status: $status",
                style: TextStyle(
                  color: status == "Expired"
                      ? Colors.red
                      : (status == "Live" ? Colors.green : Colors.blue),
                  fontWeight: FontWeight.bold,
                )),
            const Spacer(),
            if (status != "Expired") ...[
              ElevatedButton(
                onPressed: () => _registerUser(context),
                child: const Text("Register"),
              ),
              const SizedBox(height: 10),
              if (event.link.isNotEmpty)
                ElevatedButton(
                  onPressed: () => _launchLink(event.link),
                  child: const Text("Visit Event Link"),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
