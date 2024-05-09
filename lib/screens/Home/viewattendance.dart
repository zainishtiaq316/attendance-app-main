import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//import '../../models/attendance.dart';
import '../../utils/color_utils.dart'; // Assuming you have a model class for attendance data

class viewAttendance extends StatefulWidget {
  viewAttendance({super.key});

  @override
  State<viewAttendance> createState() => _viewAttendanceState();
}

class _viewAttendanceState extends State<viewAttendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "View Attendance",
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
        child: Column(
          children: [
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("MarkAttendance")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("attendance")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return Text('No data found');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final markAttendanceDocs = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: markAttendanceDocs.length,
                    itemBuilder: (context, index) {
                      final markAttendanceData = markAttendanceDocs[index]
                          .data() as Map<String, dynamic>;
                      final name = markAttendanceData['name'];
                      final rollNo = markAttendanceData['rollNo'];
                      final attendanceStatus =
                          markAttendanceData['attendanceStatus'];
                      final currentDate = markAttendanceData['CurrentDate'];

                      return Card(
                        child: InkWell(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              ListTile(
                                title: Text("Name: $name"),
                                subtitle: Text(
                                    "Roll No: $rollNo    Attendance Status: $attendanceStatus      Current Date: $currentDate"),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Confirmedleaves")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("attendance")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return Text('No data found');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final confirmedLeavesDocs = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: confirmedLeavesDocs.length,
                    itemBuilder: (context, index) {
                      final confirmedLeavesData = confirmedLeavesDocs[index]
                          .data() as Map<String, dynamic>;
                      final name = confirmedLeavesData['name'];
                      final rollNo = confirmedLeavesData['rollNo'];
                      final attendanceStatus =
                          confirmedLeavesData['attendanceStatus'];
                      final currentDate = confirmedLeavesData['currentDate'];

                      return Card(
                        child: InkWell(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              ListTile(
                                title: Text("Name : $name"),
                                subtitle: Text(
                                    "Roll No : $rollNo    Attendance Status : $attendanceStatus      Current Date : $currentDate"),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
