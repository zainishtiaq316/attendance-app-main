import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';
import 'package:studentattendance/Signup_Signin_Screen/splash.dart';
import 'package:studentattendance/models/usermodel.dart';
import 'package:studentattendance/screens/Home/Home_Screen.dart';
import 'package:studentattendance/screens/Home/viewattendance.dart';
import 'package:studentattendance/screens/Profile/Profile_Screen.dart';
import 'package:studentattendance/utils/color_utils.dart';
import 'package:studentattendance/widgets/drawerWidget.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final _pageControlller = PageController();
  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedInUser = UserModel();
  late FocusNode myFocusNode;

  DateTime? currentBackPressTime;
  int selectedDate = 1;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  late DateTime _firstDay;
  late DateTime _lastDay;
  @override
  void initState() {
    super.initState();
    _updateVisibleDays(_focusedDay);
  }

  void _updateVisibleDays(DateTime currentDate) {
    // Calculate the start and end of the current week
    _firstDay = currentDate.subtract(Duration(days: currentDate.weekday - 1));
    _lastDay = _firstDay.add(Duration(days: 6));
  }

  Future<bool> onWillPop() async {
    // myFocusNode.unfocus();
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press back again to exit');
      setState(() {
        myFocusNode.unfocus();
      });
      return Future.value(false);
    }
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplashScreen()));

    return Future.value(true);
  }

  @override
  void dispose() {
    super.dispose();
    _pageControlller.dispose();
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? name = user?.displayName;
    String? imageUrl = user?.photoURL;
    return WillPopScope(
        onWillPop: onWillPop,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Container()); // Loading indicator while fetching data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              Map<String, dynamic>? userData = snapshot.data?.data();
              String? firstName = userData?['firstName'];
              String? SecondName = userData?['secondName'];
              String? email = userData?['email'];

              return  Scaffold(
        
        drawer: DrawerWidget(),
            appBar: AppBar(
            backgroundColor: Colors.orange.shade400,
            surfaceTintColor: Colors.orange.shade400,
            centerTitle: true,
            actionsIconTheme: IconThemeData(color: Colors.blue),
            title: Text(
              "Attend easy",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Profile()));
                  },
                  child: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.white,
                    backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                    child: imageUrl == null
                        ? Text(
                            firstName != null ? firstName[0].toUpperCase() : "",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
          
      body: PageView(
            controller: _pageControlller,
            children:  <Widget>[
              HomeScreen(name: userData?['firstName'],),
              viewAttendance(),
         
            ],
          ),
          extendBody: true,
          bottomNavigationBar: RollingBottomBar(
            color: Colors.deepPurple.shade700,
            controller: _pageControlller,
            flat: true,
            useActiveColorByDefault: false,
            items: const [
              RollingBottomBarItem(Icons.home,
              
                  label: 'Home', activeColor: Colors.green, ),
              RollingBottomBarItem(Icons.view_agenda,
                  label: 'View', activeColor: Colors.red),
             
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
          },
        ));
  }
}
