import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studentattendance/Signup_Signin_Screen/splash.dart';
import 'package:studentattendance/screens/Home/calender_screen.dart';
import 'package:studentattendance/screens/Home/markattendance.dart';
import 'package:studentattendance/screens/Home/viewattendance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studentattendance/screens/Profile/Profile_Screen.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/usermodel.dart';
import '../../utils/color_utils.dart';
import '../../widgets/drawerWidget.dart';
import 'leaveattendance.dart';
import 'markattendancee.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    myFocusNode.dispose();
  }
   

  @override
  Widget build(BuildContext context) {
    String? name = user?.displayName;
    String? imageUrl = user?.photoURL;
     // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          actionsIconTheme: IconThemeData(color: Colors.blue),
          title: Text(
            "Attend easy",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: kPColor,
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
                          name != null ? name[0].toUpperCase() : "",
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
        drawer: DrawerWidget(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "Hi, ",
                      style: GoogleFonts.montserrat(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${user!.displayName}",
                      style: GoogleFonts.montserrat(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Welcome to Attendance App",
                  style: GoogleFonts.montserrat(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          
               const SizedBox(height: 20.0),
                Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(children: [
                    
                    tableCalender()
                  ]),
                ),
                  const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/attendance.png",
                    height: 200,
                  ),
                ),
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButtonContainer(
                      text: "Mark Attendance",
                      icon: Icons.check_circle,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => markatt(),
                          ),
                        );
                      },
                    ),
                    ElevatedButtonContainer(
                      text: "Mark Leave",
                      icon: Icons.event_note_outlined,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => leaveAttendance(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButtonContainer(
                      text: "View Attendance",
                      icon: Icons.visibility,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => viewAttendance(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
   void _navigateToCalendarScreen(BuildContext context, int selectedDate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarScreen(selectedDate: selectedDate),
      ),
    );
  }

  Widget tableCalender() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: TableCalendar(
         weekendDays: [DateTime.saturday, DateTime.sunday],
         
          availableCalendarFormats: {
            CalendarFormat.week: 'Week',
          },
          calendarFormat: _calendarFormat,
          startingDayOfWeek: StartingDayOfWeek.monday,
          focusedDay: _focusedDay,
          
          firstDay: _firstDay,
          lastDay: _lastDay,
          calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: kPColor, // Set your desired background color
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: Colors.black,
            ),
            weekendStyle: TextStyle(
              color: Colors.black,
            ),
          ),
          selectedDayPredicate: (day) => isSameDay(day, _focusedDay),
          calendarBuilders:
              CalendarBuilders(defaultBuilder: (context, date, events) {
            return Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSameDay(date, _focusedDay)
                    ? Colors.blue // Change color for the focused day
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: isSameDay(date, _focusedDay)
                        ? Colors.white // Change text color for the focused day
                        : Colors.black,
                  ),
                ),
              ),
            );
          }),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _focusedDay = selectedDay;
              _updateVisibleDays(_focusedDay);
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => CalendarScreen(
                          selectedDate: selectedDate,
                        ))));
                        
          },
          headerVisible: false,
          daysOfWeekVisible : true,
          daysOfWeekHeight: 30,

        ),
      ),
    );
  }
}

class ElevatedButtonContainer extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const ElevatedButtonContainer({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
