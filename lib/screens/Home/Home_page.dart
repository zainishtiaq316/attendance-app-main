import 'package:flutter/material.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';
import 'package:studentattendance/screens/Home/Home_Screen.dart';
import 'package:studentattendance/screens/Home/viewattendance.dart';
import 'package:studentattendance/widgets/drawerWidget.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final _pageControlller = PageController();

  @override
  void dispose() {
    _pageControlller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        
    body: PageView(
          controller: _pageControlller,
          children:  <Widget>[
            HomeScreen(),
            viewAttendance(),
   
          ],
        ),
        extendBody: true,
        bottomNavigationBar: RollingBottomBar(
          color: Colors.blue.shade100,
          controller: _pageControlller,
          flat: true,
          useActiveColorByDefault: false,
          items: const [
            RollingBottomBarItem(Icons.home,
            
                label: 'Home', activeColor: Colors.orange, ),
            RollingBottomBarItem(Icons.camera,
                label: 'View', activeColor: Colors.orange),
           
          ],
          enableIconRotation: true,
          onTap: (index) {
            _pageControlller.animateToPage(
              index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
            );
          },
        ),
      
    );
  }
}