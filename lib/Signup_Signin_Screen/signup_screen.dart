// ignore_for_file: body_might_complete_normally_catch_error
import 'package:flutter/widgets.dart';
import 'package:studentattendance/Signup_Signin_Screen/login_screen.dart';
import 'package:studentattendance/Signup_Signin_Screen/verificationScreen.dart';
import 'package:studentattendance/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/usermodel.dart';
import '../utils/loadingIndicator.dart';
import '../widgets/bezier-container.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  String? token;
  Future<void> getFirebaseMessagingToken() async {
    await FirebaseMessaging.instance.requestPermission();

    await FirebaseMessaging.instance.getToken().then((t) {
      if (t != null) {
        setState(() {
          token = t;
          print('Push Token: $t');
        });
      }
    });
  }

  //our form key
  final _formKey = GlobalKey<FormState>();
  //editing controller
  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final phoneNumberEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmpasswordEditingController = new TextEditingController();
  final photoUrlContainer = new TextEditingController();
  final descriptionController = new TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
      autofocus: false,
      obscureText: false,
      enableSuggestions: true,
      autocorrect: true,
      controller: firstNameEditingController,
      cursorColor: Colors.black45,
      style: TextStyle(color: Colors.black45.withOpacity(0.9)),
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name can't be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Name (Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        //new
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
          border: InputBorder.none,
          fillColor: Color(0xfff3f3f4),
          filled: true),
    );

    //last name field
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingController,
      obscureText: false,
      enableSuggestions: true,
      autocorrect: true,
      cursorColor: Colors.black45,
      style: TextStyle(color: Colors.black45.withOpacity(0.9)),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Last Name can't be Empty");
        }
        return null;
      },
      onSaved: (value) {
        //new
        lastNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Last Name",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
          border: InputBorder.none,
          fillColor: Color(0xfff3f3f4),
          filled: true),
    );

    //email field
    final emailField = TextFormField(
      autofocus: false,
      obscureText: false,
      enableSuggestions: true,
      autocorrect: true,
      controller: emailEditingController,
      cursorColor: Colors.black45,
      style: TextStyle(color: Colors.black45.withOpacity(0.9)),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        //new
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
          border: InputBorder.none,
          fillColor: Color(0xfff3f3f4),
          filled: true),
    );

    //phone number field
    final phoneNumberField = TextFormField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      autofocus: false,
      obscureText: false,
      enableSuggestions: true,
      autocorrect: true,
      controller: phoneNumberEditingController,
      cursorColor: Colors.black45,
      style: TextStyle(color: Colors.black45.withOpacity(0.9)),
      keyboardType: TextInputType.phone,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{11,}$');
        if (value!.isEmpty) {
          return ("Phone Number can't be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid phone number (Min. 11 Character)");
        }
        return null;
      },
      onSaved: (value) {
        //new
        phoneNumberEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
          border: InputBorder.none,
          fillColor: Color(0xfff3f3f4),
          filled: true),
    );

    final descriptionField = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      obscureText: false,
      enableSuggestions: true,
      autocorrect: true,
      cursorColor: Colors.black45,
      style: TextStyle(color: Colors.black45.withOpacity(0.9)),
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
      maxLines: null, // Allows the field to expand vertically based on content
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 30, 70),
          hintText: "Message",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
          border: InputBorder.none,
          fillColor: Color(0xfff3f3f4),
          filled: true),
    );
    //signup button
    final signUpButon = GestureDetector(
    onTap: () async {
  // Validate form fields before sending data
  if (_formKey.currentState!.validate()) {
    // Save form fields
    _formKey.currentState!.save();
    try{
      loader(context);

    // Call function to send data to Firestore
    await sendRegistrationDataToFirestore(
      firstName: firstNameEditingController.text,
      lastName: lastNameEditingController.text,
      email: emailEditingController.text,
      phoneNumber: phoneNumberEditingController.text,
      message: descriptionController.text,
    );

    // Show a confirmation message or navigate to another screen
    Fluttertoast.showToast(
      msg: "Registration request sent successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    }
    catch(e){
          Fluttertoast.showToast(
      msg: "Error while sending request",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    Navigator.pop(context);
    
    }
  }},
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          "Send to Admin",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    Widget _backButton() {
      return InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
              ),
              Text('Back',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
            ],
          ),
        ),
      );
    }

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: kPColor,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: const Text(
      //     "Sign Up",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () {
      //       //passing this to a route
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ),

      backgroundColor: Colors.white,
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: height * .17),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          child: Image.asset(
                            "assets/images/logo.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25,),
                      Center(child: Text("Write Message to Admin for Registration", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),)),
                   

                   SizedBox(height: 25),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                           

      
                          Text(
                            "First name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          firstNameField,
                          SizedBox(height: 10),
                          Text(
                            "Last name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          lastNameField,
                          SizedBox(height: 10),
                          Text(
                            "Email",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          emailField,
                          SizedBox(height: 10),
                          Text(
                            "Phone number",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          phoneNumberField,
                          SizedBox(height: 10),
                          Text(
                            "Message",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          descriptionField,
                          SizedBox(height: 20),
                          signUpButon,
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Already have an account  "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  "Login ",
                                  style: TextStyle(
                                      color: Color(0xffe46b10),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }


  Future<void> sendRegistrationDataToFirestore({
  required String firstName,
  required String lastName,
  required String email,
  required String phoneNumber,
  required String message,
}) async {
  try {
    // Access Firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('userRegistrationRequests');

    // Add user data to Firestore
    await users.add({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'message': message,
      // Add more fields if needed
      // 'timestamp': FieldValue.serverTimestamp(),
    });
 print("Success");

      } catch(e){
         Navigator.pop(context);
        print("Fail");
    // Handle error
  }
}

  // //signup function
  // Future<void> sendMessage(String firstName, String lastName, String email, String phoneNumber, String message) async {
  //   if (_formKey.currentState!.validate()) {
  //     loader(context);
  //     try{
  //       CollectionReference users = FirebaseFirestore.instance.collection('usersRequest');
  //       // Add user data to Firestore
  //   await users.add({
  //     'firstName': firstName,
  //     'lastName': lastName,
  //     'email': email,
  //     'phoneNumber': phoneNumber,
  //     'message': message,
  //     // Add more fields if needed
  //     // 'timestamp': FieldValue.serverTimestamp(),
  //   });
 
  //       Fluttertoast.showToast(msg: "Registration Request Send to Admin !");

  //     } catch(e){
  //        Navigator.pop(context);
  //       Fluttertoast.showToast(msg: "Error found while sending data to admin!");

  //     };
      
      
  //   }
  // }

}
