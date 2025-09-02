import 'package:evently/features/auth/onboarding.dart';
import 'package:evently/features/auth/signup_page.dart';
import 'package:evently/features/main_page.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/services/auth_service.dart';
import 'package:evently/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final AuthService auth = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
    bool isLoading = false;

  bool showPassword = false;

  void signin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter email and password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result != null && result.toString().contains('@')) {
        // Fetch and set user in provider
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.setUser(result); // fetches user by email

        final user = userProvider.user;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("User data could not be loaded"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // 👇 Navigate based on onboarded
        if (user.isOnboarded) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScaffold()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result ?? "User not found"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("Sign in error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF3EFD4), // black background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login to your Account',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: emailController,
                label: "Email",
                keyboardType: TextInputType.emailAddress,
                icon: const Icon(Icons.email),
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
                  const Text(
                    "Show Password",
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    value: showPassword,
                    onChanged: (value) {
                      setState(() {
                        showPassword = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : signin,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    child: Text("Sign In"),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
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
