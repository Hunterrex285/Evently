import 'package:evently/features/main_page.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Store onboarding values
  String? dept;
  String? year;
  String? gender;
  String? bio;
  String? avatar;

  final List<String> avatars = [
    "assets/avatars/avatar1.png",
    "assets/avatars/avatar2.png",
    "assets/avatars/avatar3.png",
  ];

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _finishOnboarding();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScaffold()));
    }
  }

  void _finishOnboarding() async {
    // ✅ Save user data to Firestore/UserProvider here
    await context.read<UserProvider>().updateUserDetails({
      "dept": dept,
      "yearOfPassing": year,
      "gender": gender,
      "bio": bio ?? "",
      "avatar": avatar,
      "isOnboarded": true,
    });

    print(
        "Dept: $dept, Year: $year, Gender: $gender, Bio: $bio, Avatar: $avatar");
  }

  Widget _buildPage(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          child,
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _nextPage,
            child: Text(_currentPage == 4 ? "Finish" : "Next"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // force step by step
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        children: [
          _buildPage(
            "Select Department",
            DropdownButtonFormField<String>(
              value: dept,
              hint: const Text("Choose department",
                  style: TextStyle(color: Colors.black54)),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  borderSide: const BorderSide(color: Colors.black, width: 3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
              dropdownColor: Colors.white, // Dropdown menu background
              icon: const Icon(Icons.arrow_drop_down,
                  color: Colors.black), // Arrow icon
              style: const TextStyle(
                  color: Colors.black, fontSize: 16), // Text style
              items: ["CSE", "ECE", "ME", "Civil"].map((d) {
                return DropdownMenuItem(
                  value: d,
                  child: Text(d),
                );
              }).toList(),
              onChanged: (val) => setState(() => dept = val),
            ),
          ),
          _buildPage(
            "Select Year of Passing",
            DropdownButton<String>(
              value: year,
              hint: const Text("Choose year"),
              items: ["2025", "2026", "2027"].map((y) {
                return DropdownMenuItem(value: y, child: Text(y));
              }).toList(),
              onChanged: (val) => setState(() => year = val),
            ),
          ),
          _buildPage(
            "Select Gender",
            Column(
              children: ["Male", "Female", "Other"].map((g) {
                return RadioListTile(
                  title: Text(g),
                  value: g,
                  groupValue: gender,
                  onChanged: (val) => setState(() => gender = val.toString()),
                );
              }).toList(),
            ),
          ),
          _buildPage(
            "Add Bio (optional)",
            TextField(
              decoration: const InputDecoration(hintText: "Write a short bio"),
              onChanged: (val) => bio = val,
            ),
          ),
          _buildPage(
            "Choose Avatar",
            Wrap(
              spacing: 10,
              children: avatars.map((a) {
                return GestureDetector(
                  onTap: () => setState(() => avatar = a),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: avatar == a ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(a, width: 80, height: 80),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
