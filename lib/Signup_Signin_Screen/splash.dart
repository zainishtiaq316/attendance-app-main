import 'package:studentattendance/Signup_Signin_Screen/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Set a delay for the splash screen
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the home screen after the delay
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your app logo or any other UI elements
            Image.asset(
                'assets/images/logo.png'), // Replace with your actual logo path
            SizedBox(height: 16),
            //CircularProgressIndicator(), // Add a loading indicator if desired
          ],
        ),
      ),
    );
  }
}
