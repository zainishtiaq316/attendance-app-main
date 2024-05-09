import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/Home/Home_Screen.dart';
import '../screens/Profile/Profile_Screen.dart';
import '../utils/color_utils.dart';
import '../widgets/drawerWidget.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
