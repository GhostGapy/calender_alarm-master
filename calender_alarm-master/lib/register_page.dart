import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'package:calender_alarm/user_provider.dart';
import 'package:calender_alarm/users.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:calender_alarm/login.dart';
import 'package:provider/provider.dart'; // Import the LoginPage

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _register() {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    final provider = Provider.of<UserProvider>(context, listen: false);

    if (email.isNotEmpty &&
        password.isNotEmpty &&
        password == confirmPassword) {
      // Check if email is already used
      bool isEmailTaken =
          provider.registeredUsers.any((user) => user.email == email);

      if (isEmailTaken) {
        // Email is already used
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Registration Failed'),
              content: const Text('This email is already registered.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Generate a unique ID for the new user
        final String newUserId = const Uuid().v4();

        // Hash the password
        final hashedPassword = sha256.convert(utf8.encode(password)).toString();

        // Save registration data
        final registrationData =
            RegistrationData(newUserId, email, hashedPassword);
        provider.addUser(registrationData);

        // Navigate to the next page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } else {
      // Passwords don't match or fields are empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Failed'),
            content: const Text(
                'Please make sure passwords match and all fields are filled.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  'Registration Page',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
            const SizedBox(height: 20.0),
            RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: const TextStyle(
                  color: Color.fromARGB(255, 199, 199, 199),
                  fontSize: 14.0,
                ),
                children: [
                  TextSpan(
                    text: "Login",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = navigateToLoginPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
