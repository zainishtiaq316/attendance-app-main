import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studentattendance/Signup_Signin_Screen/splash.dart';
import 'package:studentattendance/screens/Profile/edit_profile.dart';
import 'package:studentattendance/screens/Profile/helpScreen.dart';
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
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    UserModel loggedInUser = UserModel();
    String? name = user?.displayName;
    String? imageUrl = user?.photoURL;
    return Scaffold(
        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: Colors.blue),
          title: Text(
            "Settings",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: kPColor,
            ),
          ),
        ),
        drawer: DrawerWidget(),
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: kPColor,
                )); // Loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                Map<String, dynamic>? userData = snapshot.data?.data();
                String? firstName = userData?['firstName'];
                String? SecondName = userData?['secondName'];
                String? email = userData?['email'];

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.17,
                          decoration: BoxDecoration(
                              color: kPColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 45.0,
                                      backgroundColor: Colors.white,
                                      backgroundImage: imageUrl != null
                                          ? NetworkImage(imageUrl)
                                          : null,
                                      child: imageUrl == null
                                          ? Text(
                                              name != null
                                                  ? name[0].toUpperCase()
                                                  : "",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            )
                                          : null,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${firstName} ${SecondName}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${email}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Positioned(
                                  right: 30,
                                  top: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap:(){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfileScreen()));
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          size: 30,
                                          color: Colors.green.shade900,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.45,
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
                                          builder: (context) => AccountInfo()));
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
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "My Account",
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
                                              ChangePasswordScreen()));
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
                                          Icons.password_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Change Password",
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

                                onTap:(){

                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> HelpCenterScreen()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, left: 15, right: 15, bottom: 15),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width *
                                            0.10,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Icon(
                                          Icons.help_center,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Help Center",
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

                                onTap :(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> DeveloperContactPage()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, left: 15, right: 15, bottom: 15),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width *
                                            0.10,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Icon(
                                          Icons.contact_page,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Contact",
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
                                  AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.noHeader,
                                      animType: AnimType.bottomSlide,
                                      title: 'Logout ',
                                      desc: 'Are you sure?',
                                      btnCancelOnPress: () {
                                        Navigator.of(context).pop();
                                      },
                                      btnOkOnPress: () async {
                                        loader(context);
                                        await logout(context);
                                      }).show();
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
                                          Icons.logout,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Logout",
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
                );
              }
            }));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplashScreen()));
  }
}
