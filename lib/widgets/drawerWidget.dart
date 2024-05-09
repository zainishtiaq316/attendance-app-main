import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studentattendance/screens/Profile/Profile_Screen.dart';
import 'package:studentattendance/utils/color_utils.dart';

import '../models/usermodel.dart';
import '../screens/Home/Home_Screen.dart';
import '../screens/Profile/settings_screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String? name = user?.displayName;
  String? imageUrl = user?.photoURL;

    return  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: kPColor,)); // Loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic>? userData = snapshot.data?.data();
          String? firstName = userData?['firstName'];
          String? SecondName = userData?['secondName'];
          String? email = userData?['email'];

          return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Drawer(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0))),
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Container(
                  color: Color(0xfff7892b),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.32,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.white,
                          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                        child: imageUrl == null ? Text(
                          name != null ? name[0].toUpperCase() : "",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ) : null,
                      ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${firstName} ${SecondName}" ?? "",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            email??"",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )),
                ),
               SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                    },
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        "Home",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      leading: Icon(
                        Icons.home,
                       color: Colors.black,
                          weight: 12,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                          weight: 12
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Profile()));
                    },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        "Profile",
                        style: TextStyle(
                         color: Colors.black,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      leading: Icon(
                        Icons.person,
                        color: Colors.black,
                          weight: 12
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                       color: Colors.black,
                          weight: 12,
                      ),
                    ),
                  ),
                ),
                 InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SettingScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        "Settings",
                        style: TextStyle(
                         color: Colors.black,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      leading: Icon(
                        Icons.settings,
                        color: Colors.black,
                          weight: 12
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                       color: Colors.black,
                          weight: 12,
                      ),
                    ),
                  ),
                ),
                // InkWell(
                //   onTap: (){
                //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SettingScreen()));
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 20.0,
                //     ),
                //     child: ListTile(
                //       titleAlignment: ListTileTitleAlignment.center,
                //       title: Text(
                //         "Settings",
                //         style: TextStyle(
                //           color: Colors.black,
                //           fontWeight: FontWeight.w600
                //         ),
                //       ),
                //       leading: Icon(
                //         Icons.settings,
                //        color: Colors.black,
                //           weight: 12,
                //       ),
                //       trailing: Icon(
                //         Icons.arrow_forward_ios,
                //        color: Colors.black,
                //           weight: 12,
                //       ),
                //       onTap: () {
                //         // Get.back();
                //         // Get.to(()=>AllOrdersScreen());
                //       },
                //     ),
                //   ),
                // ),
                
                
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      "Contact",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    leading: Icon(
                      Icons.help,
                      color: Colors.black,
                        weight: 12
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                     color: Colors.black,
                        weight: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: ListTile(
                    onTap: () async {
                      // GoogleSignIn googleSignIn = GoogleSignIn();
                      // FirebaseAuth _auth = FirebaseAuth.instance;
                      // await _auth.signOut();
                      // await googleSignIn.signOut();
                      // Get.offAll(WelcomeScreen());
                    },
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      "Logout",
                      style: TextStyle(
                       color: Colors.black,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    leading: Icon(
                      Icons.logout,
                      color: Colors.black,
                        weight:12
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                     color: Colors.black,
                        weight: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.grey.shade400),
    );}
      },
    );}
}
