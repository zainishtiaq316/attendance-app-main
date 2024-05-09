import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
 

  @override
  Widget build(BuildContext context) {
     final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
      bool _obscurePassword = true;
       @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

      
 final passwordField = TextFormField(
      autofocus: false,
      enableSuggestions: false,
      autocorrect: false,
      controller: _passwordController,
      cursorColor: Colors.black45,
      obscureText: _obscurePassword,
      style: TextStyle(color: Colors.black45.withOpacity(0.9)),
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password (Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        //new
        _passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
         
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscurePassword =
                    !_obscurePassword; // Toggle visibility
              });
            },
            icon: Icon(
              // ignore: dead_code
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          
           hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
           border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true
         ),
    );
    return Scaffold(
      body: Form(
      key: _formKey,
      child: Column(
       children: [
          SizedBox(height: 15),
          passwordField,
          SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                // Ensure passwords match
                if (_passwordController.text !=null) {
                  try {
                    // Get the current user
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      // Update the password
                      await user.updatePassword(_passwordController.text);
                      // Password updated successfully
                      print('Password updated successfully');
                    }
                  } catch (e) {
                    print('Error updating password: $e');
                  }
                } else {
                  // Passwords don't match
                  print('Passwords do not match');
                }
              } else {
                // Form validation failed
                print('Form validation failed');
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    )

    );}

 
}
