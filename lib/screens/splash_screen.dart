
import 'package:api_flutter/screens/my_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:api_flutter/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // If the user is logged in, navigate to the HomeScreen.
    if (isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
    } else {
      // If not logged in, navigate to the LoginScreen.
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.red,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Baqalati',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black),
            ),
            Text(
              'Buy your Products Online',
              style: TextStyle(fontSize: 20, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
