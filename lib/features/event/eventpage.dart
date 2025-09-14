import 'package:evently/widgets/textfield.dart';
import 'package:flutter/material.dart';

class EventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EventPage(),
    );
  }
}

class EventPage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> events = [
    {
      'title': 'Tech Conference 2025',
      'organizer': 'Google',
      'location': 'Jakarta',
      'type': 'Full time',
      'price': '\$800/Mo'
    },
    {
      'title': 'Startup Workshop',
      'organizer': 'Microsoft',
      'location': 'Jakarta',
      'type': 'Full time',
      'price': '\$1200/Mo'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Replaced Search Bar with AppTextField
          AppTextField(
            controller: searchController,
            label: "Search an event",
            icon: const Icon(Icons.search),
          ),

          const SizedBox(height: 16),

          // Event Categories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: const [
                      Text("20K",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("Full Time"),
                      SizedBox(height: 10),
                      Icon(Icons.event, size: 30, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: const [
                      Text("18K",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("Part Time"),
                      SizedBox(height: 10),
                      Icon(Icons.event_available, size: 30, color: Colors.red),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Recent Events
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recent Events",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {},
                child: const Text("See All"),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.event),
                    ),
                    title: Text(event['title']!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event['organizer']!),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 4),
                            Text(event['location']!),
                            const SizedBox(width: 10),
                            const Icon(Icons.access_time, size: 16),
                            const SizedBox(width: 4),
                            Text(event['type']!),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(event['price']!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
