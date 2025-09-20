import 'package:evently/features/auth/onboarding.dart';
import 'package:evently/features/auth/signin_page.dart';
import 'package:evently/widgets/textfield.dart';
import '../../services/auth_service.dart';
import 'package:flutter/material.dart';

class ClubSignUpPage extends StatefulWidget {
  const ClubSignUpPage({super.key});

  @override
  State<ClubSignUpPage> createState() => _ClubSignUpPageState();
}

class _ClubSignUpPageState extends State<ClubSignUpPage> {
  final authService = AuthService();
  final nameController = TextEditingController(); // club name
  final categoryController = TextEditingController(); // new field
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUpClub() async {
    setState(() => isLoading = true);
    try {
      final result = await authService.signUpClub(
        clubName: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (result != null && result.contains('@')) {
        // ⚡ For now just show success since clubs won’t use UserProvider
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Sign Up Successful"),
            content: Text("Welcome, ${nameController.text}!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OnboardingPage(), // custom onboarding for clubs
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );

        // ✅ Clear fields
        nameController.clear();
        categoryController.clear();
        emailController.clear();
        passwordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result ?? "Something went wrong"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print("SignUpClub error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create your Club Account',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: nameController,
                label: "Club Name",
                icon: const Icon(Icons.groups),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: categoryController,
                label: "Category (e.g. Technical, Cultural)",
                icon: const Icon(Icons.category),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: emailController,
                label: "Email",
                icon: const Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: passwordController,
                label: "Password",
                obscureText: !showPassword,
                icon: const Icon(Icons.lock),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text("Show Password", style: TextStyle(color: Colors.black)),
                  Checkbox(
                    value: showPassword,
                    onChanged: (value) {
                      setState(() => showPassword = value!);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : signUpClub,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign Up"),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const SigninPage()),
                    );
                  },
                  child: const Text(
                    "Already have an account? Sign In",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
