import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.black,
            width: double.infinity,
            child: const Center(
              child: Text('Profile'),
            ),
          ),
        ],
      ),
    );
  }
}
