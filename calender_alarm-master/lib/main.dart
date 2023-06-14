import 'package:calender_alarm/root_page.dart';
import 'package:flutter/material.dart';
import 'package:calender_alarm/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:calender_alarm/login.dart';
import 'package:calender_alarm/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(const AlarmCalender());
}

class AlarmCalender extends StatelessWidget {
  const AlarmCalender({Key? key}); // Remove 'super.key' as it is not needed

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ), // Add UserProvider here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
        ),
        home: FutureBuilder<bool>(
          future: checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final bool isLoggedIn = snapshot.data!;
              return isLoggedIn ? const RootPage() : const LoginPage();
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }
}
