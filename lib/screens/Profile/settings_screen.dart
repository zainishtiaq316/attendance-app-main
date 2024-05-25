import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studentattendance/Signup_Signin_Screen/splash.dart';
import 'package:studentattendance/screens/Profile/change_email.dart';
import 'package:studentattendance/screens/Profile/edit_profile.dart';
import 'package:studentattendance/screens/Profile/helpScreen.dart';
import 'package:studentattendance/screens/Profile/language_settings.dart';
import 'package:studentattendance/screens/Profile/myaccount.dart';
import 'package:studentattendance/utils/color_utils.dart';

import '../../Signup_Signin_Screen/change_password.dart';
import '../../models/usermodel.dart';
import '../../utils/loadingIndicator.dart';
import '../../widgets/drawerWidget.dart';
import 'developer_contact.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late FocusNode myFocusNode;

  DateTime? currentBackPressTime;
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
    
    
    // ignore: deprecated_member_use
    return WillPopScope(
       onWillPop: onWillPop,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange.shade400,
            surfaceTintColor: Colors.orange.shade400,
            actionsIconTheme: IconThemeData(color: Colors.blue),
            title: Text(
              "Settings",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
      
          drawer: DrawerWidget(),
          body: Container(
            height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.blue.shade900,  Colors.orange.shade300],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
            child: SingleChildScrollView(
                      child: Column(
                        children: [
                         Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top :10,bottom: 20),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.22,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey, blurRadius: 2)
                                  ],
                                  borderRadius: BorderRadius.circular(30)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditProfileScreen()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 15, right: 15, bottom: 15),
                                      child: Row(
                                        children: [
                                          Container(
                                            width:
                                                MediaQuery.of(context).size.width *
                                                    0.10,
                                            height:
                                                MediaQuery.of(context).size.height *
                                                    0.05,
                                            decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Icon(
                                              Icons.edit_note_outlined,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Edit Profile",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Spacer(),
                                          Icon(Icons.arrow_forward_ios)
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade300,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeEmail()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 15, right: 15, bottom: 15),
                                      child: Row(
                                        children: [
                                          Container(
                                            width:
                                                MediaQuery.of(context).size.width *
                                                    0.10,
                                            height:
                                                MediaQuery.of(context).size.height *
                                                    0.05,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Icon(
                                              Icons.contact_mail,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Change Email",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Spacer(),
                                          Icon(Icons.arrow_forward_ios)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.09,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey, blurRadius: 2)
                                  ],
                                  borderRadius: BorderRadius.circular(30)),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> LanguageSettings()));
                                   },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 15, right: 15, bottom: 15),
                                      child: Row(
                                        children: [
                                          Container(
                                            width:
                                                MediaQuery.of(context).size.width *
                                                    0.10,
                                            height:
                                                MediaQuery.of(context).size.height *
                                                    0.05,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Icon(
                                              Icons.language,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Language Settings",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Spacer(),
                                          Icon(Icons.arrow_forward_ios)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
          )
              
              
              
              ),
    );
            
            
            
            
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplashScreen()));
  }

}
