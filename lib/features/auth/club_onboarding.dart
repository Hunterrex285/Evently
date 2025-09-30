import 'dart:io';
import 'package:evently/features/main_page.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ClubOnboardingPage extends StatefulWidget {
  const ClubOnboardingPage({super.key});

  @override
  State<ClubOnboardingPage> createState() => _ClubOnboardingPageState();
}

class _ClubOnboardingPageState extends State<ClubOnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Store onboarding values
  String? orgName;
  String? email;
  String? description;
  late String logo;

  File? _logoFile;
  bool _isUploading = false;

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _logoFile = File(picked.path);
      });
    }
  }

  Future<void> _uploadLogo() async {
    if (_logoFile == null) return;

    setState(() => _isUploading = true);

    final ref = FirebaseStorage.instance
        .ref()
        .child("club_logos")
        .child("${DateTime.now().millisecondsSinceEpoch}.png");

    await ref.putFile(_logoFile!);
    final url = await ref.getDownloadURL();

    setState(() {
      logo = url; // save Firebase URL
      _isUploading = false;
    });
  }

  int currentIndex = 0;

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _finishOnboarding();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScaffold()),
      );
    }
  }

  void _finishOnboarding() async {
    await context.read<UserProvider>().updateUserDetails({
      "orgName": orgName,
      "email": email,
      "description": description ?? "",
      "logo": logo,
      "isOnboarded": true,
      "role": "club", // fixed
      "isVerified": false,
    });

    print(
        "Club Onboarding -> Name: $orgName, Email: $email, Desc: $description, Logo: $logo");
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
            child: Text(_currentPage == 3 ? "Finish" : "Next"),
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
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          _buildPage(
            "Add Short Description",
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Tell students about your club...",
              ),
              onChanged: (val) => description = val,
            ),
          ),
          _buildPage(
            "Upload Club Logo",
            Column(
              children: [
                GestureDetector(
                  onTap: _pickLogo,
                  child: CircleAvatar(
                    radius: 72,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        _logoFile != null ? FileImage(_logoFile!) : null,
                    child: _logoFile == null
                        ? const Icon(Icons.add_a_photo,
                            size: 40, color: Colors.black54)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _uploadLogo,
                  icon: const Icon(Icons.cloud_upload),
                  label: Text(
                      _isUploading ? "Uploading..." : "Upload to Firebase"),
                ),
                if (logo.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text("✅ Logo uploaded successfully"),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
