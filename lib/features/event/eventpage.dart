import 'package:evently/features/event/event_details_page.dart';
import 'package:flutter/material.dart';
import 'package:evently/services/event_service.dart';
import 'package:evently/models/event_model.dart';

class EventPage extends StatelessWidget {
  final EventService _eventService = EventService();

  EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Event>>(
        stream: _eventService.getAllEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading events"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = [];

          if (events.isEmpty) {
            return const Center(child: Text("No events found"));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final now = DateTime.now();

              String status;
              if (event.startTime.isAfter(now)) {
                status = "Upcoming";
              } else if (event.endTime.isBefore(now)) {
                status = "Expired";
              } else {
                status = "Live";
              }

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(event.title),
                  subtitle: Text(
                    "$status • ${event.startTime} - ${event.endTime}",
                    style: TextStyle(
                      color: status == "Expired"
                          ? Colors.red
                          : (status == "Live" ? Colors.green : Colors.blue),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailsPage(event: event),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}


