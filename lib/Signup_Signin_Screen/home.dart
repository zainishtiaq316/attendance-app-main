import 'package:flutter/material.dart';
import 'package:studentattendance/widgets/drawerWidget.dart';

class HomeScreenElement extends StatefulWidget {
  const HomeScreenElement({super.key});

  @override
  State<HomeScreenElement> createState() => _HomeScreenElementState();
}

class _HomeScreenElementState extends State<HomeScreenElement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
       actionsIconTheme: IconThemeData(color: Colors.amber),
      ),
      drawer: DrawerWidget(),
    );
  }
}