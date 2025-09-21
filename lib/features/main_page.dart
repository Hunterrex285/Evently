import 'package:evently/features/profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:evently/features/home/home.dart';
import 'package:evently/features/event/eventpage.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;

  final List<Widget> _pages = [
    const CollegeHomePage(),
    EventPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF9F5EC);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Main content with custom AppBar
          Column(
            children: [
              _buildAppBarForIndex(_selectedIndex),
              Expanded(child: _pages[_selectedIndex]),
            ],
          ),

          // Fullscreen Drawer
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _isDrawerOpen ? 0 : -MediaQuery.of(context).size.width,
            top: 0,
            bottom: 0,
            right: _isDrawerOpen ? 0 : MediaQuery.of(context).size.width,
            child: Container(
              color: Colors.white,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drawer Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close,
                            size: 32,
                                color: Colors.black87),
                            onPressed: () {
                              setState(() {
                                _isDrawerOpen = false;
                              });
                            },
                          ),
                          const Text(
                            "Evently",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              color: Colors.black87,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          const SizedBox(width: 48), // balance spacing
                        ],
                      ),
                    ),
                    const SizedBox(height: 64),

                    // Menu Items
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          spacing: 48,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildDrawerItem("Home", 0),
                        _buildDrawerItem("Events", 1),
                        _buildDrawerItem("Profile", 2),
                          ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build AppBars dynamically as widgets
  Widget _buildAppBarForIndex(int index) {
    switch (index) {
      case 0:
        return _customAppBar("Evently");
      case 1:
        return _customAppBar("College Events");
      case 2:
        return _customAppBar("Profile");
      default:
        return _customAppBar("Evently");
    }
  }

  // Custom top bar
  Widget _customAppBar(String title,
      {double fontSize = 27, double height = 118}) {
    return Container(
      color: const Color(0xFF1947E5),
      height: height,
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isDrawerOpen = true;
                });
              },
              icon: const Icon(Icons.menu, color: Colors.white),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Drawer Item Widget
  Widget _buildDrawerItem(String title, int index) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          _isDrawerOpen = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 44,
            fontFamily: 'Montserrat',

            color: isSelected ? Colors.deepOrange : Colors.black87,
          ),
        ),
      ),
    );
  }
}
