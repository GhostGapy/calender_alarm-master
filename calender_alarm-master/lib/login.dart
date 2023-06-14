import 'dart:convert';
import 'package:calender_alarm/root_page.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:calender_alarm/register_page.dart';
import 'package:provider/provider.dart';
import 'package:calender_alarm/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void saveLoginStatus(bool isLoggedIn, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
    prefs.setString('userId', userId);
  }

  void navigateToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void navigateToRootPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RootPage()),
    );
  }

  void login() {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final registeredUsers = userProvider.registeredUsers;

    bool isUserFound = false;
    String userId = "";
    for (final user in registeredUsers) {
      if (user.email == email && user.password == hashedPassword) {
        isUserFound = true;
        userId = user.id;
        break;
      }
    }

    if (isUserFound) {
      // User found, perform the necessary actions (e.g., navigate to the root page)
      navigateToRootPage();
      saveLoginStatus(
        true,
        userId,
      );
    } else {
      // User not found, show an error message or handle unsuccessful login
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid email or password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  'Login Page',
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
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20.0),
            RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                  color: Color.fromARGB(255, 199, 199, 199),
                  fontSize: 14.0,
                ),
                children: [
                  TextSpan(
                    text: "Register",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = navigateToRegisterPage,
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
