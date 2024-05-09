import 'package:studentattendance/Admin/Edit/Edit.dart';

import 'package:studentattendance/Admin/leave/LeaveRequests.dart';
import 'package:studentattendance/Admin/viewrecord/Viewrecord.dart';
import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Attendance App",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(
                'assets/images/admin.png', // Replace with your image path
                height: 100,

                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            AdminButton(
              icon: Icons.list_alt,
              label: 'View All Records',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewRecord()));
              },
            ),
            SizedBox(height: 20),
            AdminButton(
              icon: Icons.edit,
              label: 'Edit Attendance',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditAttendance()));
              },
            ),
            SizedBox(height: 20),
            AdminButton(
              icon: Icons.approval,
              label: 'Leave Approval',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LeaveRequests()));
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class AdminButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const AdminButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue, // Customize the button color here
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white, // Customize the icon color here
                ),
                SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white, // Customize the text color here
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
