import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studentattendance/screens/Home/check_in_screen.dart';
import 'package:studentattendance/screens/Home/check_out_screen.dart';

import '../../utils/color_utils.dart';
import 'dart:core';

class markatt extends StatefulWidget {
  const markatt({super.key});

  @override
  State<markatt> createState() => _markattState();
}

class _markattState extends State<markatt> {
  String _selectedButton = 'CheckIn'; // Default selected button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kPColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Mark Attendance",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              //passing this to a route
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Check-In & Check-Out",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 25, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedButton = 'CheckIn';
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                       colors: _selectedButton =="CheckIn"?[Colors.blue.shade200, Colors.blue.shade900] : [ Colors.white, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                              // color: _selectedButton =="CheckIn"?Colors.green.shade800 : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color :Colors.blue.shade900 ),
                              ),
                          child: Center(
                              child: Text(
                            "Check-In",
                            style: TextStyle(
                                color: _selectedButton =="CheckIn"?Colors.white : Colors.blue.shade900,
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
                            _selectedButton = 'CheckOut';
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                             gradient: LinearGradient(
                        colors:   _selectedButton =="CheckOut"?[Colors.red.shade200, Colors.cyan.shade900] : [Colors.white, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                              // color: _selectedButton =="CheckOut"?Colors.red.shade800 : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              
                                border: Border.all(color :Colors.cyan.shade900 ),),
                          child: Center(
                              child: Text(
                            "Check-Out",
                            style: TextStyle(
                               color: _selectedButton =="CheckOut"?Colors.white : Colors.cyan.shade900,
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
            child: _selectedButton == 'CheckIn'
                ? CheckIn()
                : CheckOut(),
          ),

          
        ],
      ),
        
        
        
        // Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       GestureDetector(
        //         onTap: (){
        //           Navigator.push(context, MaterialPageRoute(builder: (context)=> CheckInScreen()));
        //         },
        //         child: Container(
        //           width: MediaQuery.of(context).size.width * 0.7,
        //           height: MediaQuery.of(context).size.height * 0.3,
        //           decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [Colors.blue.shade200, Colors.blue.shade900],
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      // ),
        //               borderRadius: BorderRadius.circular(30)),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Container(
        //                   width: MediaQuery.of(context).size.width * 0.1,
        //                   height: MediaQuery.of(context).size.height * 0.1,
        //                   decoration: BoxDecoration(
        //                       shape: BoxShape.circle,
        //                       border: Border.all(
        //                         color: Colors.white,
        //                         width: 2
        //                       )),
        //                   child: Icon(
        //                     Icons.keyboard_double_arrow_down_outlined,
        //                     color: Colors.white,
        //                     size: 30,
                         
        //                   )),
        //               SizedBox(
        //                 width: 5,
        //               ),
        //               Text(
        //                 "Check-In",
        //                 style: TextStyle(
        //                     color: Colors.white,
        //                     fontSize: 30,
        //                     fontWeight: FontWeight.w600),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         height: 30,
        //       ),
        //       GestureDetector(
        //         onTap: (){
        //           Navigator.push(context, MaterialPageRoute(builder: (context)=> CheckOutScreen()));
        //         },
        //         child: Container(
        //           width: MediaQuery.of(context).size.width * 0.7,
        //           height: MediaQuery.of(context).size.height * 0.3,
        //           decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [Colors.red.shade200, Colors.red.shade900],
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      // ),
        //               borderRadius: BorderRadius.circular(30)),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Container(
        //                   width: MediaQuery.of(context).size.width * 0.1,
        //                   height: MediaQuery.of(context).size.height * 0.1,
        //                   decoration: BoxDecoration(
        //                       shape: BoxShape.circle,
        //                       border: Border.all(
        //                         color: Colors.white,
        //                          width: 2
        //                       )),
        //                   child: Icon(
        //                     Icons.keyboard_double_arrow_up_outlined,
        //                     color: Colors.white,
        //                     size: 30,
        //                   )),
        //               SizedBox(
        //                 width: 5,
        //               ),
        //               Text(
        //                 "Check-Out",
        //                 style: TextStyle(
        //                     color: Colors.white,
        //                     fontSize: 30,
        //                     fontWeight: FontWeight.w600),
        //               )
        //             ],
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // )
        // 
        );
  
  
  }
   Widget CheckIn() {
    return CheckInScreen(); }

  Widget CheckOut() {
    return CheckOutScreen();}


}
