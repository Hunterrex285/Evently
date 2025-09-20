import 'package:evently/features/event/event_details_page.dart';
import 'package:flutter/material.dart';
import 'package:evently/services/event_service.dart';
import 'package:evently/models/event_model.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final EventService _eventService = EventService();
  String selectedTab = "Upcoming";
  final List<Event> dummyEvents = [
  Event(
    id: "1",
    title: "TechFest 2025",
    description: "Annual college tech festival with coding, robotics, and AI workshops.",
    startTime: DateTime(2025, 10, 5, 10, 0),
    endTime: DateTime(2025, 10, 5, 18, 0),
    link: "https://techfest2025.com",
    bannerUrl: "https://picsum.photos/800/300?random=1",
    organizer: "ACME University",
  ),
  Event(
    id: "2",
    title: "Photography Walk",
    description: "Explore campus through the lens and capture creative shots.",
    startTime: DateTime(2025, 9, 15, 7, 30),
    endTime: DateTime(2025, 9, 15, 11, 0),
    link: "https://photowalk.com",
    bannerUrl: "https://picsum.photos/800/300?random=2",
    organizer: "Lens Club",
  ),
  Event(
    id: "3",
    title: "Startup Pitch Night",
    description: "Showcase innovative startup ideas in front of industry mentors.",
    startTime: DateTime(2025, 9, 25, 18, 0),
    endTime: DateTime(2025, 9, 25, 21, 0),
    link: "https://startupnight.com",
    bannerUrl: "https://picsum.photos/800/300?random=3",
    organizer: "E-Cell",
  ),
  Event(
    id: "4",
    title: "Music Jam Session",
    description: "Open mic and jam session for all music enthusiasts.",
    startTime: DateTime(2025, 10, 2, 17, 0),
    endTime: DateTime(2025, 10, 2, 20, 0),
    link: "https://musicjam.com",
    bannerUrl: "https://picsum.photos/800/300?random=4",
    organizer: "Cultural Committee",
  ),
  Event(
    id: "5",
    title: "Blood Donation Camp",
    description: "Join the noble cause and donate blood to save lives.",
    startTime: DateTime(2025, 9, 10, 9, 0),
    endTime: DateTime(2025, 9, 10, 14, 0),
    link: "https://blooddonation.org",
    bannerUrl: "https://picsum.photos/800/300?random=5",
    organizer: "Red Cross",
  ),
];



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: ["Upcoming", "Expired", "Live"].map((tab) {
                  final isSelected = selectedTab == tab;
                  return Expanded(
                    // Expanded should wrap GestureDetector
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = tab;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center, // centers text inside
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF00C6AE)
                              : const Color.fromARGB(0, 255, 135, 135),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          tab,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
        ),

        // Events List
        Expanded(
          child: StreamBuilder<List<Event>>(
            stream: _eventService.getAllEvents(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Error loading events"));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final now = DateTime.now();
              final events = snapshot.data!.where((event) {
                if (selectedTab == "Upcoming") {
                  return event.startTime.isAfter(now);
                } else if (selectedTab == "Expired") {
                  return event.endTime.isBefore(now);
                } else {
                  return event.startTime.isBefore(now) &&
                      event.endTime.isAfter(now);
                }
              }).toList();

              if (dummyEvents.isEmpty) {
                return const Center(child: Text("No events found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: dummyEvents.length,
                itemBuilder: (context, index) {
                  final event = dummyEvents[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventDetailsPage(event: event),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(12),
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
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
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
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
