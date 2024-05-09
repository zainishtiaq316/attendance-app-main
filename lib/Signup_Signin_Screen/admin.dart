import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/color_utils.dart';
import '../Admin/adminBN.dart';

class Admin extends StatelessWidget {
  const Admin({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Admin",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "This email account is admin account",
                style: GoogleFonts.montserrat(
                    color: black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Text(
            "Choose where you want to go",
            style: GoogleFonts.montserrat(color: black),
          ),
          const SizedBox(height: 20.0),
          InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AdminBottomNav()),
                  (route) => false);
            },
            child: Container(
              margin: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: kPColor,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Center(
                  child: Text(
                    "Admin Side",
                    style: GoogleFonts.openSans(
                        color: Colors.white,
                        // fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
