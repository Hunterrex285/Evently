import 'package:evently/features/auth/onboarding.dart';
import 'package:evently/features/auth/signin_page.dart';
import 'package:evently/features/main_page.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/widgets/textfield.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final authService = AuthService();
  final nameController = TextEditingController();
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

  void signUp() async {
    setState(() => isLoading = true);
    try {
      final result = await authService.signUpWithEmailAndPassword(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print(result);

      // ✅ Show success in AlertDialog

      if (result != null && result.toString().contains('@')) {
        // Fetch user by email
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.setUser(
            result.toString()); // setUser should fetch UserModel by email

        final user = userProvider.user;

        if (user != null) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Sign Up Successful"),
              content: Text("Welcome, ${user.name}!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => user.isOnboarded
                            ? MainScaffold()
                            : OnboardingPage(), // Navigate based on onboarding status
                      ),
                    );
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }

        // ✅ Clear fields
        nameController.clear();
        emailController.clear();
        passwordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result ?? "No User"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // prevents the screen from resizing

      backgroundColor: const Color(0xFFF3EFD4),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Create your Account',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Montserrat')),
              SizedBox(height: 2),
              AppTextField(
                controller: nameController,
                label: "Name",
                icon: const Icon(Icons.person),
              ),
              SizedBox(height: 12),
              AppTextField(
                controller: emailController,
                label: "Email",
                icon: const Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12),
              AppTextField(
                controller: passwordController,
                label: "Password",
                obscureText: true,
                icon: const Icon(Icons.lock),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Show Password", style: TextStyle(color: Colors.black)),
                  Checkbox(
                    value: showPassword,
                    onChanged: (value) {
                      setState(() {
                        showPassword = value!;
                      });
                    },
                  ),
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : signUp,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    child: Text("Sign Up"),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SigninPage()),
                    );
                  },
                  child: Text("Already have an account? Sign In",
                      style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
