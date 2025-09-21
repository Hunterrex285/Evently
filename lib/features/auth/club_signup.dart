import 'package:evently/features/auth/onboarding.dart';
import 'package:evently/features/auth/rolepage.dart';
import 'package:evently/features/auth/signin_page.dart';
import 'package:evently/widgets/textfield.dart';
import 'package:evently/widgets/button.dart';
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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;

  @override
  void dispose() {
    nameController.dispose();
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
                      builder: (context) => OnboardingPage(),
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );

        nameController.clear();
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const RolePage()),
                  );
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

              const SizedBox(height: 48),

              // Title
              const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'You have chance to create new account if you really want to.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
              ),

              const SizedBox(height: 24),

              // Fields
              AppTextField(
                controller: nameController,
                label: "Club Name",
                icon: const Icon(Icons.groups),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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

              const SizedBox(height: 12),

              // Sign Up Button
              Button(
                isLoading: isLoading,
                action: signUpClub,
                text: "Sign Up",
              ),

              const SizedBox(height: 12),

              // Sign In Link
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
