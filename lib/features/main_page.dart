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
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const CollegeHomePage(),
    EventPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF9F5EC);

    // Build AppBars dynamically based on user name
    final List<PreferredSizeWidget?> appBars = [
      AppBar(
        centerTitle: true,
        toolbarHeight: 118, // taller height
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFF1947E5),
        leading: IconButton(
          onPressed: () {},
          icon:
              const Icon(Icons.menu, color: Color.fromARGB(221, 255, 255, 255)),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 16), // push text lower
          child: Align(
            alignment: Alignment.bottomCenter, // align title to bottom
            child: Text(
              "Evently",
              style: const TextStyle(
                color: Color.fromARGB(221, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 27,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none,
                color: Color.fromARGB(221, 255, 255, 255)),
          ),
        ],
      ),  
      AppBar(
        centerTitle: true,
        toolbarHeight: 180, // taller height
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFF1947E5),
        leading: IconButton(
          onPressed: () {},
          icon:
              const Icon(Icons.menu, color: Color.fromARGB(221, 255, 255, 255)),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 16), // push text lower
          child: Align(
            alignment: Alignment.bottomCenter, // align title to bottom
            child: Text(
              "College\nEvents",
              style: const TextStyle(
                color: Color.fromARGB(221, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 44,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none,
                color: Color.fromARGB(221, 255, 255, 255)),
          ),
        ],
      ),  
      AppBar(
        centerTitle: true,
        toolbarHeight: 118, // taller height
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFF1947E5),
        leading: IconButton(
          onPressed: () {},
          icon:
              const Icon(Icons.menu, color: Color.fromARGB(221, 255, 255, 255)),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 16), // push text lower
          child: Align(
            alignment: Alignment.bottomCenter, // align title to bottom
            child: Text(
              "Profile",
              style: const TextStyle(
                color: Color.fromARGB(221, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 27,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none,
                color: Color.fromARGB(221, 255, 255, 255)),
          ),
        ],
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
