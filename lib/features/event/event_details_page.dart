import 'package:evently/models/event_model.dart';
import 'package:evently/models/participants_model.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/services/event_service.dart';
import 'package:evently/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final user = context.read<UserProvider>().user;
    final participant = Participant(
      uid: user!.uid,
      name: user.name,
      email: user.email,
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(0), bottom: Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 0,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event image placeholder
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                      ),
                    ),

                    // Event title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 4.0),
                      child: Text(
                        event.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                      child: Text(
                        event.organizer,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Status: $status",
                              style: TextStyle(
                                color: status == "Expired"
                                    ? Colors.red
                                    : (status == "Live"
                                        ? Colors.green
                                        : Colors.blue),
                                fontWeight: FontWeight.bold,
                              )),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Text(
                            event.description,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 16),
                        Text("Start: ${event.startTime}"),
                        Text("End: ${event.endTime}"),
                        const SizedBox(height: 16),
                        if (event.link.isNotEmpty)
                          Row(
                            children: [
                              Text("Featured Link: "),
                              TextButton(
                                onPressed: () => _launchLink(event.link),
                                child: Text(event.title),
                              ),
                            ],
                          ),
                        
                      ],
                    ),
                  ),
                ),
              ),
              if (status != "Expired") ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: Button(
                              isLoading: false,
                              action: () {
                                _registerUser(context);
                              },
                              text: "Register",
                            ),
                          ),
                        ]
                        else ...[
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "This event has expired.",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]
            ],
          ),
          Positioned(
            top: 32,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(48.0),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
