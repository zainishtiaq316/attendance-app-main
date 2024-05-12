import 'package:flutter/material.dart';
import 'package:studentattendance/utils/color_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  int? selectedDate;

  CalendarScreen({this.selectedDate});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    void _onDaySelected(DateTime day, DateTime focusedDay) {
      setState(() {
        today = day;
      });
      Navigator.of(context).pop(widget.selectedDate);
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "Calendar",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                availableGestures: AvailableGestures.all,
                focusedDay: today,
                selectedDayPredicate: (day) => isSameDay(day, today),
                firstDay: DateTime.utc(1900, 10, 16),
                lastDay: DateTime.utc(3000, 3, 14),
                onDaySelected: _onDaySelected,
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: kPColor, // Set your desired background color
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
