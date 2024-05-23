import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/color_utils.dart'; // Assuming you have a model class for attendance data

class viewAttendance extends StatefulWidget {
  viewAttendance({super.key});

  @override
  State<viewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<viewAttendance> {
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
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20),
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
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          color: _selectedButton == "View Attendance"
                              ? Colors.green.shade800
                              : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.green.shade800),
                        ),
                        child: Center(
                            child: Text(
                          "Check In/Out",
                          style: TextStyle(
                              color: _selectedButton == "View Attendance"
                                  ? Colors.white
                                  : Colors.green.shade800,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedButton = 'Leave Attendance';
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          color: _selectedButton == "Leave Attendance"
                              ? Colors.red.shade800
                              : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.red.shade800),
                        ),
                        child: Center(
                            child: Text(
                          "Leaves",
                          style: TextStyle(
                              color: _selectedButton == "Leave Attendance"
                                  ? Colors.white
                                  : Colors.red.shade800,
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
        SizedBox(height: 80)
      ],
    );
  }

  Widget buildViewAttendance() {
    return StreamBuilder(
      stream: _fetchAttendanceData(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: kPColor,
            ),
          );
        }

        final checkInDocs = snapshot.data!['checkIn'] as List<DocumentSnapshot>;
        final checkOutDocs = snapshot.data!['checkOut'] as List<DocumentSnapshot>;

        if (checkInDocs.isEmpty) {
          return Center(
            child: Text('No check-in data found'),
          );
        }

        return ListView.builder(
          itemCount: checkInDocs.length,
          itemBuilder: (context, index) {
            final checkInData = checkInDocs[index].data() as Map<String, dynamic>;
            final checkOutData = checkOutDocs.isNotEmpty && checkOutDocs.length > index
                ? checkOutDocs[index].data() as Map<String, dynamic>?
                : null;

            final name = checkInData['name'];
            final rollNo = checkInData['rollNo'];
            final attendanceStatus = checkInData['attendanceStatus'];
            final currentDate = checkInData['CurrentDate'];
            final checkInTime = checkInData['time'];
            final checkOutTime = checkOutData?['time'];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
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
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "Attendance Status: ",
                              style: TextStyle(
                                  color: Colors.green.shade800, fontSize: 15),
                            ),
                            Text(
                              "$attendanceStatus",
                              style: TextStyle(
                                  color: Colors.green.shade800, fontSize: 15),
                            ),
                            if (checkOutTime != null)
                              Text(
                                " & Check-Out",
                                style: TextStyle(
                                    color: Colors.red.shade800, fontSize: 15),
                              ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Current Date: $currentDate",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height * 0.04,
                              child: Image.asset(
                                "assets/images/checkin.png",
                                color: Colors.green.shade800,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(checkInTime,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15)),
                            if (checkOutTime != null) ...[
                              SizedBox(width: 20),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.height * 0.04,
                                child: Image.asset(
                                  "assets/images/checkout.png",
                                  color: Colors.red.shade800,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(checkOutTime,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                            ],
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
  }

 Widget buildLeaveAttendance() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection("MarkAttendance")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("leaves")
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
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
          child: Text('No data found'),
        );
      }

      return ListView.builder(
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
                      SizedBox(height: 5),
                      Text(
                        "Roll No: $rollNo",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Attendance Status: $attendanceStatus",
                        style: TextStyle(
                            color: Colors.green.shade800, fontSize: 15),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Current Date: $currentDate",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.height * 0.04,
                            child: Image.asset(
                              "assets/images/leave.png",
                              color: Colors.purple.shade800,
                            ),
                          ),
                          SizedBox(width: 5),
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
  );
}

  Stream<Map<String, dynamic>> _fetchAttendanceData() async* {
    final checkInSnapshot = await FirebaseFirestore.instance
        .collection("MarkAttendance")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("CheckIn")
        .snapshots();

    final checkOutSnapshot = await FirebaseFirestore.instance
        .collection("MarkAttendance")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("CheckOut")
         .snapshots();

   await for (final checkInData in checkInSnapshot) { // Changed await to await for
    await for (final checkOutData in checkOutSnapshot) { // Changed await to await for
      yield {
        'checkIn': checkInData.docs,
        'checkOut': checkOutData.docs,
      };
    }
  
   }}
}
