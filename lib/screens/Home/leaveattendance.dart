import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../models/usermodel.dart';
import '../../utils/color_utils.dart';
import 'dart:core';

import '../../utils/loadingIndicator.dart';

class leaveAttendance extends StatefulWidget {
  const leaveAttendance({super.key});

  @override
  State<leaveAttendance> createState() => _leaveAttendanceState();
}

class _leaveAttendanceState extends State<leaveAttendance> {
  final nameController = TextEditingController();
  final rollNoController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final currentDateController = TextEditingController();
  final attendanceStatusController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;
  UserModel loggedInUser = UserModel();
  //User? user = FirebaseAuth.instance.currentUser;
  String? uid;
  String? userToken;
  FirebaseAuth _auth = FirebaseAuth.instance;
  // Method to check if the user is signed in with Firebase Auth
  bool isSignedInWithFirebase() {
    return _auth.currentUser != null;
  }

  void checkAuthentication() async {
    bool isSignedInFirebase = isSignedInWithFirebase();
    if (isSignedInFirebase) {
      final id = auth.currentUser!.uid;
      setState(() {
        uid = id;
      });
      FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get()
          .then((value) {
        this.loggedInUser = UserModel.fromMap(value.data());
        setState(() {
          userToken = loggedInUser.token;
        });
        emailController.text = loggedInUser.email!;
        rollNoController.text = loggedInUser.rollNo!;
        contactController.text = loggedInUser.phoneNumber ?? '';
        nameController.text =
            '${loggedInUser.firstName} ${loggedInUser.secondName}';
      });
      print('User is signed in with Firebase Auth');
    } else {
      print('User is not signed in');
    }
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
    // Set the current date in the currentDateController
    //DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat.yMd().format(DateTime.now());
    currentDateController.text = formattedDate;
    attendanceStatusController.text = "Leave";
    //emailController.text = '${user!.email}';
    //contactController.text = user!.phoneNumber ?? '';
    //nameController.text = '${user!.displayName}';
    //emailController.text = emailController.text;
    //contactController.text = contactController.text;
  }

  Future<bool> checkAttendance() async {
    // Get the current date as a string
    String currentDate = DateFormat.yMd().format(DateTime.now());
    // Get the user ID from Firebase Auth
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Query the subcollection where you store the attendance data
    List<QuerySnapshot> snapshots = await Future.wait([
      FirebaseFirestore.instance
          .collection('MarkAttendance')
          .doc(userId) // Use the user ID as the document ID
          .collection('attendance')
          .where('CurrentDate', isEqualTo: currentDate)
          .get(),
      FirebaseFirestore.instance
          .collection('Confirmedleaves')
          .doc(userId) // Use the user ID as the document ID
          .collection('attendance')
          .where('currentDate', isEqualTo: currentDate)
          .get(),
    ]);
    // Check if there are any documents in the snapshot
    if (snapshots.any((snapshot) => snapshot.docs.isNotEmpty)) {
      // The attendance or leave is already marked on the current date
      return true;
    } else {
      // The attendance or leave is not marked yet
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    rollNoController.dispose();
    contactController.dispose();
    emailController.dispose();
    attendanceStatusController.dispose();
    currentDateController.dispose();
    descriptionController.dispose();
    // dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Leave Attendance",
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
      body: FutureBuilder<bool>(
          // Pass your query function as the future argument
          future: checkAttendance(),
          // Define a builder function that returns a widget based on the state of the future
          builder: (context, snapshot) {
            // Check if the future is completed
            if (snapshot.connectionState == ConnectionState.done) {
              // Check if the future returned true or false
              if (snapshot.data == true) {
                // The attendance is already marked on the current date, so return a message widget
                return Center(
                  child: Text('You have already marked your attendance today.'),
                );
              } else {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.black45,
                          style:
                              TextStyle(color: Colors.black45.withOpacity(0.9)),
                          controller: nameController,
                          enabled: false,
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
                            nameController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Name",
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.3),
                            hintStyle: TextStyle(
                                color: Colors.black45.withOpacity(0.9)),
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
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          autofocus: false,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.black45,
                          style:
                              TextStyle(color: Colors.black45.withOpacity(0.9)),
                          controller: rollNoController,
                          enabled: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Admin Assign You Roll Number",
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.3),
                            hintStyle: TextStyle(
                                color: Colors.black45.withOpacity(0.9)),
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
                            rollNoController.text = value!;
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
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          obscureText: false,
                          controller: attendanceStatusController,
                          enabled: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.black45,
                          style:
                              TextStyle(color: Colors.black45.withOpacity(0.9)),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{3,}$');
                            if (value!.isEmpty) {
                              return ("Attendance Status");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter Attendance Status");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            //new
                            attendanceStatusController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Attendance Status",
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.3),
                            hintStyle: TextStyle(
                                color: Colors.black45.withOpacity(0.9)),
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
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          autofocus: false,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.black45,
                          style:
                              TextStyle(color: Colors.black45.withOpacity(0.9)),
                          enabled: false,
                          controller: contactController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Phone Number",
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.3),
                            hintStyle: TextStyle(
                                color: Colors.black45.withOpacity(0.9)),
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
                            contactController.text = value!;
                          },
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{11,}$');
                            if (value!.isEmpty) {
                              return ("Phone Number can't be Empty");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter Valid Phone number");
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autofocus: false,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.black45,
                          style:
                              TextStyle(color: Colors.black45.withOpacity(0.9)),
                          enabled: false,
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Your Email");
                            }
                            //reg expression for email validation
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please Enter a valid email");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            //new
                            emailController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Email",
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.3),
                            hintStyle: TextStyle(
                                color: Colors.black45.withOpacity(0.9)),
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
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.datetime,
                          autofocus: false,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          controller: currentDateController,
                          cursorColor: Colors.black45,
                          style:
                              TextStyle(color: Colors.black45.withOpacity(0.9)),
                          enabled: false,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "field required";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            //new
                            currentDateController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Current Date",
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.3),
                            hintStyle: TextStyle(
                                color: Colors.black45.withOpacity(0.9)),
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
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        // Adjust the height as per your requirement
                        TextFormField(
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.black45,
                          style:
                              TextStyle(color: Colors.black45.withOpacity(0.9)),
                          controller: descriptionController,
                          enabled: true,
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{3,}$');
                            if (value!.isEmpty) {
                              return ("Description can't be Empty");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter Description");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            descriptionController.text = value!;
                          },
                          textInputAction: TextInputAction.done,
                          maxLines:
                              null, // Allows the field to expand vertically based on content
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 30, 40),
                            hintText: "Description",
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.3),
                            hintStyle: TextStyle(
                                color: Colors.black45.withOpacity(0.9)),
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
                        ),

                        SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final name = nameController.text;
                            final rollNo = rollNoController.text;
                            final email = emailController.text;
                            final contact = contactController.text;
                            final attendanceStatus =
                                attendanceStatusController.text;
                            final currentDate = currentDateController.text;
                            final description = descriptionController.text;

                            if (rollNo.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Missing Roll Number"),
                                    content: Text(
                                        "Please wait for the admin to assign you a roll number."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: kPColor),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (formKey.currentState!.validate()) {
                              loader(context);
                              await joinUplaod(
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                name,
                                rollNo,
                                email,
                                contact,
                                attendanceStatus,
                                userToken!,
                                currentDate,
                                description,
                              ).whenComplete(() {
                                Navigator.pop(context);

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Your request is pending"),
                                      content: Text(
                                          "Stay tuned with us for the latest updates."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "OK",
                                            style: TextStyle(color: kPColor),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            }
                          },
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            } //first if
            else {
              // The future is not completed yet, so return a loading indicator widget
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

Future<void> joinUplaod(
    String id,
    String name,
    String rollNo,
    String email,
    String contact,
    String attendanceStatus,
    String userToken,
    String currentDate,
    String description) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  // final image = FirebaseAuth.instance.currentUser!.photoURL;
  await FirebaseFirestore.instance.collection("JoinRequests").doc(id).set({
    'id': id,
    'name': name,
    'rollNo': rollNo,
    'contact': contact,
    'email': email,
    'attendanceStatus': attendanceStatus,
    'CurrentDate': currentDate,
    'description': description,
    'userId': uid,
    'userToken': userToken,
  });
}
