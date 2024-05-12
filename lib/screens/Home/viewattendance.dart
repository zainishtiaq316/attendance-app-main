import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

//import '../../models/attendance.dart';
import '../../utils/color_utils.dart'; // Assuming you have a model class for attendance data

class viewAttendance extends StatefulWidget {
  viewAttendance({super.key});

  @override
  State<viewAttendance> createState() => _viewAttendanceState();
}

class _viewAttendanceState extends State<viewAttendance> {
  String _selectedButton = 'View Attendance'; // Default selected button

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
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            //passing this to a route
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedButton = 'View Attendance';
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                          color: Colors.green.shade800,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        "Check In/Out",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedButton = 'Leave Attendance';
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                          color: Colors.red.shade800,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        "Leaves",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: _selectedButton == 'View Attendance'
                ? buildViewAttendance()
                : buildLeaveAttendance(),
          )
        ],
      ),
    );
  }

  Widget buildViewAttendance() {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("MarkAttendance")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("CheckIn")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: kPColor,
              ),
            );
          }

          final markAttendanceDocs = snapshot.data!.docs;

          if (markAttendanceDocs.isEmpty) {
            return Center(
              child: Text('No data found'),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: markAttendanceDocs.length,
            itemBuilder: (context, index) {
              final markAttendanceData =
                  markAttendanceDocs[index].data() as Map<String, dynamic>;
              final name = markAttendanceData['name'];
              final rollNo = markAttendanceData['rollNo'];
              final attendanceStatus = markAttendanceData['attendanceStatus'];
              final currentDate = markAttendanceData['CurrentDate'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Name: $name",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5,),
                          Text("Roll No: $rollNo", style: TextStyle(color: Colors.black, fontSize: 15),),
                          SizedBox(height: 5,),
                          Text("Attendance Status: $attendanceStatus",style: TextStyle(color: Colors.green.shade800, fontSize: 15),),
                          SizedBox(height: 5,),
                          Text("Current Date: $currentDate",style: TextStyle(color: Colors.black, fontSize: 15),),
                          
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildLeaveAttendance() {
    return SingleChildScrollView(
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
            return Center(
              child: CircularProgressIndicator(
                color: kPColor,
              ),
            );
          }

          final confirmedLeavesDocs = snapshot.data!.docs;

          if (confirmedLeavesDocs.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Text('No data found'),
                ],
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: confirmedLeavesDocs.length,
            itemBuilder: (context, index) {
              final confirmedLeavesData =
                  confirmedLeavesDocs[index].data() as Map<String, dynamic>;
              final name = confirmedLeavesData['name'];
              final rollNo = confirmedLeavesData['rollNo'];
              final attendanceStatus = confirmedLeavesData['attendanceStatus'];
              final currentDate = confirmedLeavesData['currentDate'];

              return   Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Name: $name",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5,),
                          Text("Roll No: $rollNo", style: TextStyle(color: Colors.black, fontSize: 15),),
                          SizedBox(height: 5,),
                          Text("Attendance Status: $attendanceStatus",style: TextStyle(color: Colors.green.shade800, fontSize: 15),),
                          SizedBox(height: 5,),
                          Text("Current Date: $currentDate",style: TextStyle(color: Colors.black, fontSize: 15),),
                          
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            
            },
          );
        },
      ),
    );
  }
}
