import 'package:flutter/material.dart';
import 'package:calender_alarm/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'change_pass.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key});

  Future<void> changePassword(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
      (route) => false,
    );
  }

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.setString('userId', "");
  }

  Future<void> logout(BuildContext context) async {
    clearUserData();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red, // Set the desired color for the button
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
