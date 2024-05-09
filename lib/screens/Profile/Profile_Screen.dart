import 'dart:io';
import 'package:studentattendance/Signup_Signin_Screen/change_password.dart';
import 'package:studentattendance/screens/Profile/profile_menu.dart';
import 'package:studentattendance/screens/Profile/uplader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studentattendance/widgets/drawerWidget.dart';

import '../../Signup_Signin_Screen/login_screen.dart';
import '../../models/usermodel.dart';
import '../../pages/homepage.dart';
import '../../utils/assureDialog.dart';
import '../../utils/color_utils.dart';
import '../../utils/loadingIndicator.dart';
import 'helpScreen.dart';
import 'myaccount.dart';
import 'myimagePicker.dart';

final profileIcon =
    "https://warranty.aquaoasis.com/images/icons/profile-icon.png";

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  File? pickImage;
  final _imgPicker = MyImagePicker();
  final UploaderService uploaderService = UploaderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.blue),
        title: Text(
                "Profile",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: kPColor,
                ),
              ),
       
      ),
       drawer: DrawerWidget(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.44,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 2,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: pickImage == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) {
                                    return Image.asset(
                                      "assets/images/user.png",
                                      fit: BoxFit.cover,
                                    );
                                  },
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${user?.photoURL != null ? user?.photoURL : profileIcon}",
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(500),
                                child: Image.file(
                                  pickImage!,
                                  fit: BoxFit.cover,
                                ),
                              )),
                    Positioned(
                        bottom: 10,
                        right: 5,
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: GestureDetector(
                                  onTap: () async {
                                    final file = await _imgPicker.pickImage();

                                    if (file != null) {
                                      setState(() {
                                        pickImage = file;
                                      });
                                    }
                                  },
                                  child: Icon(Icons.camera_alt,
                                      color: Colors.black)),
                            ))),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            // Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
            //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            // Text("${loggedInUser.email}",
            //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            Text("${user!.displayName}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            Text(
                // "${loggedInUser.firstName} ${loggedInUser.secondName}",
                "${user!.email}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            pickImage != null
                ? InkWell(
                    onTap: () async {
                      loader(context);
                      final image = await uploaderService.uploadFile(
                          pickImage!, "Profile_Images", FileType.Image);

                      // await FirebaseDatabase.instance
                      //     .ref("Users")
                      //     .child(FirebaseAuth.instance.currentUser!.uid)
                      //     .update({"photoURL": image.downloadLink});
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({"photoURL": image.downloadLink});

                      await FirebaseAuth.instance.currentUser!
                          .updatePhotoURL(image.downloadLink)
                          .whenComplete(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));

                        Fluttertoast.showToast(msg: "Profile Updated");

                        setState(() {
                          pickImage = null;
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: kPColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            "Update Picture",
                            style: GoogleFonts.openSans(
                                color: Colors.white,
                                // fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Divider(
                color: black,
                thickness: 0.5,
              ),
            ),
            ProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountInfo()),
                )
              },
            ),
            ProfileMenu(
              text: "Change Password",
              icon: "assets/icons/User Icon.svg",
              press: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                )
              },
            ),
            // ProfileMenu(
            //   text: "Settings",
            //   icon: "assets/icons/Settings.svg",
            //   press: () {},
            // ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpCenterScreen()),
                );
              },
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () {
                assuranceDialog(context, () async {
                  loader(context);
                  await logout(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
