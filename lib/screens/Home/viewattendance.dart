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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "View Attendance",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 30, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 20,),
                Row(
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
                              color: _selectedButton =="View Attendance"?Colors.green.shade800 : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color :Colors.green.shade800 ),
                              ),
                          child: Center(
                              child: Text(
                            "Check In/Out",
                            style: TextStyle(
                                color: _selectedButton =="View Attendance"?Colors.white : Colors.green.shade800,
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
                              color: _selectedButton =="Leave Attendance"?Colors.red.shade800 : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              
                                border: Border.all(color :Colors.red.shade800 ),),
                          child: Center(
                              child: Text(
                            "Leaves",
                            style: TextStyle(
                               color: _selectedButton =="Leave Attendance"?Colors.white : Colors.red.shade800,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedButton == 'View Attendance'
                ? buildViewAttendance()
                : buildLeaveAttendance(),
          ),

           SizedBox(height: 80,)
        ],
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
        builder: (context, checkInSnapshot) {
          if (checkInSnapshot.hasError) {
            return Text('Error: ${checkInSnapshot.error}');
          }

          if (!checkInSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: kPColor,
              ),
            );
          }

          final markCheckInDocs = checkInSnapshot.data!.docs;

          if (markCheckInDocs.isEmpty) {
            return Center(
              child: Text('No check-in data found'),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: markCheckInDocs.length,
            itemBuilder: (context, index) {
              final markCheckInData =
                  markCheckInDocs[index].data() as Map<String, dynamic>;
              final name = markCheckInData['name'];
              final rollNo = markCheckInData['rollNo'];
              final attendanceStatus = markCheckInData['attendanceStatus'];
              final currentDate = markCheckInData['CurrentDate'];
              final CheckInTime = markCheckInData['time'];

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("MarkAttendance")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("CheckOut")
                    .snapshots(),
                builder: (context, checkOutSnapshot) {
                  if (checkOutSnapshot.hasError) {
                    return Text('Error: ${checkOutSnapshot.error}');
                  }

                  if (!checkOutSnapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: kPColor,
                      ),
                    );
                  }

                  final markCheckOutDocs = checkOutSnapshot.data!.docs;

                  final hasCheckedOut = markCheckOutDocs.isNotEmpty;
                  final markCheckOutData = hasCheckedOut
                      ? markCheckOutDocs[index].data() as Map<String, dynamic>
                      : null;
                  final attendanceStatusField = hasCheckedOut
                      ? markCheckOutData!['attendanceStatus']
                      : null;
                  final CheckOutTime =
                      hasCheckedOut ? markCheckOutData!['time'] : null;

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
                              SizedBox(height: 5),
                              Text(
                                "Roll No: $rollNo",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  if (attendanceStatus == "Check-In")
                                    Row(
                                      children: [
                                        Text(
                                          "Attendance Status: ",
                                          style: TextStyle(
                                              color: Colors.green.shade800,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          "$attendanceStatus",
                                          style: TextStyle(
                                              color: Colors.green.shade800,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  if (attendanceStatusField == "Check-Out")
                                    Row(
                                      children: [
                                        Text(
                                          " & ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          "$attendanceStatusField",
                                          style: TextStyle(
                                              color: Colors.red.shade800,
                                              fontSize: 15),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Current Date: $currentDate",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  if (attendanceStatus == "Check-In")
                                    Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          child: Image.asset(
                                            "assets/images/checkin.png",
                                            color: Colors.green.shade800,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(CheckInTime,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15)),
                                      ],
                                    ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  if (attendanceStatusField == "Check-Out")
                                    Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          child: Image.asset(
                                            "assets/images/checkout.png",
                                            color: Colors.red.shade800,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("$CheckOutTime",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15)),
                                      ],
                                    )
                                ],
                              ),
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
              final leave = confirmedLeavesData['time'];

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
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Roll No: $rollNo",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Attendance Status: $attendanceStatus",
                            style: TextStyle(
                                color: Colors.green.shade800, fontSize: 15),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Current Date: $currentDate",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                child: Image.asset(
                                  "assets/images/leave.png",
                                  color: Colors.purple.shade800,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("$leave",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                            ],
                          ),
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
