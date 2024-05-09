/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../../models/attendance.dart';
//import '../../models/usermodel.dart';
import '../../utils/color_utils.dart';
import 'countdowntimer.dart';

class MarkAttendanceScreen extends StatefulWidget {
  final String userId;

  MarkAttendanceScreen({required this.userId});

  @override
  _MarkAttendanceScreenState createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _rollNumberController = TextEditingController();
  String _attendanceStatus = 'Present';
  String _currentDate = DateFormat('MMM d, yyyy').format(DateTime.now());
  bool _isSubmitted = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    checkAttendanceSubmission();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void checkAttendanceSubmission() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(widget.userId)
          .get();
      final attendanceData = snapshot.data();

      if (attendanceData != null && attendanceData['date'] == _currentDate) {
        setState(() {
          _isSubmitted = true;
        });
      }
    } catch (e) {
      print('Error checking attendance submission: $e');
    }
  }

  void startTimer() {
    final nextDay = DateTime.now().add(Duration(days: 1));
    final nextDayStart = DateTime(nextDay.year, nextDay.month, nextDay.day);
    final timeUntilNextDay = nextDayStart.difference(DateTime.now()).inSeconds;

    _timer = Timer(Duration(seconds: timeUntilNextDay), () {
      setState(() {
        _isSubmitted = false;
        _currentDate = DateFormat('MMM d, yyyy').format(DateTime.now());
      });
    });
  }

  void _submitForm() async {
    if (_isSubmitted) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      AttendanceData data = AttendanceData(
        name: _nameController.text,
        rollNumber: _rollNumberController.text,
        attendanceStatus: _attendanceStatus,
        date: _currentDate,
      );

      try {
        await FirebaseFirestore.instance
            .collection('attendance')
            .doc(widget.userId)
            .set(data.toMap());

        // Add the userId to the data in the database
        data.toMap()['userId'] = widget.userId;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Attendance marked successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        setState(() {
          _isSubmitted = true;
        });
      } catch (e) {
        print('Error marking attendance: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Mark Attendance",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            //passing this to a route
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                autofocus: false,
                obscureText: false,
                controller: _nameController,
                enableSuggestions: true,
                autocorrect: true,
                cursorColor: Colors.black45,
                style: TextStyle(color: Colors.black45.withOpacity(0.9)),
                keyboardType: TextInputType.name,
                validator: (value) {
                  RegExp regex = new RegExp(r'^.{3,}$');
                  if (value!.isEmpty) {
                    return ("Name can't be Empty");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Enter Valid Name (Min. 3 Character)");
                  }
                  return null;
                },
                onSaved: (value) {
                  //new
                  _nameController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Name",
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white.withOpacity(0.3),
                  hintStyle: TextStyle(color: Colors.black45.withOpacity(0.9)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Colors.blueGrey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                enabled: !_isSubmitted,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                controller: _rollNumberController,
                autofocus: false,
                obscureText: false,
                enableSuggestions: true,
                autocorrect: true,
                cursorColor: Colors.black45,
                style: TextStyle(color: Colors.black45.withOpacity(0.9)),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Roll Number",
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white.withOpacity(0.3),
                  hintStyle: TextStyle(color: Colors.black45.withOpacity(0.9)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 2,
                      style: BorderStyle.solid,
                      color: Colors.blueGrey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                onSaved: (value) {
                  //new
                  _rollNumberController.text = value!;
                },
                textInputAction: TextInputAction.done,
                validator: (value) {
                  RegExp regex = new RegExp(r'^.{6,}$');
                  if (value!.isEmpty) {
                    return ("Roll Number can't be Empty");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Enter Valid Roll number");
                  }
                  return null;
                },
                enabled: !_isSubmitted,
              ),
              SizedBox(height: 16.0),
              IgnorePointer(
                ignoring: _isSubmitted,
                child: DropdownButtonFormField<String>(
                  value: _attendanceStatus,
                  style: TextStyle(color: Colors.black45.withOpacity(0.9)),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    labelText: "Attendance Status",
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white.withOpacity(0.3),
                    hintStyle:
                        TextStyle(color: Colors.black45.withOpacity(0.9)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 2,
                        style: BorderStyle.solid,
                        color: Colors.blueGrey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _attendanceStatus = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select an attendance status';
                    }
                    return null;
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Present',
                      child: Text(
                        'Present',
                        style: TextStyle(
                          color: Colors.black45.withOpacity(0.9),
                        ),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Absent',
                      child: Text(
                        'Absent',
                        style: TextStyle(
                          color: Colors.black45.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.07,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Date: $_currentDate',
                  style: TextStyle(
                    color: Colors.black45.withOpacity(0.9),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.27,
                  height: 40,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: ElevatedButton(
                    onPressed: _isSubmitted ? null : _submitForm,
                    child: Text(
                      'Submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black;
                        }
                        return Colors.blueGrey;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_isSubmitted)
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        'Attendance already submitted for today',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      CountdownTimer(
                        endTime: DateTime.now()
                            .add(Duration(days: 1))
                            .millisecondsSinceEpoch,
                        onEnd: () {
                          setState(() {
                            _isSubmitted = false;
                            _currentDate = DateFormat('MMM d, yyyy')
                                .format(DateTime.now());
                          });
                        },
                        widgetBuilder: (_, CurrentRemainingTime? time) {
                          if (time == null) {
                            return SizedBox.shrink();
                          }

                          return Text(
                            'Form will be enabled in ${time.hours.toString().padLeft(2, '0')}:${time.minutes.toString().padLeft(2, '0')}:${time.seconds.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Colors.black45.withOpacity(0.9),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
*/