import 'package:evently/features/profile/user_profile.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:evently/features/home/home.dart';
import 'package:provider/provider.dart';
import 'package:evently/features/event/eventpage.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CollegeHomePage(),
    EventPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final user = userProvider.user;
    final bg = const Color(0xFFF3EFD4);

    // Build AppBars dynamically based on user name
    final List<PreferredSizeWidget?> appBars = [
      AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF3EFD4),
        title: Text(
          "Greetings, ${user?.name.split(" ").first ?? "Student"}!",
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
          ),
        ],
      ),
      AppBar(
        
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF3EFD4),
        title: Text(
          "Events",
          style: const TextStyle(color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
          ),
        ],
      ),
      AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: appBars[_selectedIndex],
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.event_outlined), label: 'Events'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
