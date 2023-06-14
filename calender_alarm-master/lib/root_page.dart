import 'package:flutter/material.dart';
import 'package:calender_alarm/calender_page.dart';
import 'package:calender_alarm/home_page.dart';
import 'package:calender_alarm/profile_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 1;
  List<Widget> pages = [
    const CalenderPage(),
    const HomePage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Alarm Calender ',
              style: TextStyle(
                fontFamily: 'OpenSansBold',
                fontSize: 22.0,
              ),
            ),
            Icon(
              Icons.alarm,
              color: Colors.white,
              size: 25.0,
            ),
          ],
        ),
      ),
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: 'Calender'),
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
