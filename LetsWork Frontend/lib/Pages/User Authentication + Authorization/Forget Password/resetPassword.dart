import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/Config/config.dart';
import 'package:frontend/Pages/User%20Authentication%20+%20Authorization/login.dart';
import 'package:http/http.dart' as http;

class resetPassword extends StatefulWidget {
  final String email;

  const resetPassword({required this.email, super.key});

  @override
  State<resetPassword> createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  //                     Variables
  Color mainColor = Color(0xff236F14);
  Color SecondaryColor = Color(0xFF29D924);
  Color textColor = Colors.white;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true; // Controls confirm password visibility

  //                     Variables

  //                      functions
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  void updatePassword() async {
    var regbody = {"email": widget.email, "password": _passwordController.text};
    var response = await http.post(Uri.parse(updatePasswordU),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regbody));

    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      showToast("Password Updated Successfully");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => login()),
      );
    } else {
      String errorMessage = jsonResponse['error'] ?? 'Unknown error';
      showToast("Error: $errorMessage. Please try again.");
    }
  }

  //                      functions
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerWidth = screenWidth * 0.8;
    double containerHeight = screenHeight * 0.5;
    return Scaffold(
      body: SafeArea(
          child: Center(
              child: ListView(
        children: [
          Column(
            children: [
              Text("LetsWork",
                  style: TextStyle(
                      color: SecondaryColor,
                      fontFamily: 'title',
                      fontSize: 50)),
              Container(
                width: containerWidth,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(
                      20.0), // Adjust the radius as needed
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sign Up',
                        style: TextStyle(
                            color: textColor,
                            fontFamily: 'title',
                            fontSize: 50)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 8) {
                                  return 'Password should be at least 8 characters long';
                                }
                                // You can add more advanced password validation logic here if needed
                                return null;
                              },
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(color: Color(0xFF9ACD81)),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 14.0),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      color: SecondaryColor,
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            // TextFormField - Password

                            SizedBox(height: 10.0),

                            TextFormField(
                              controller: _confirmPasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                hintText: 'Confirm your password',
                                hintStyle: TextStyle(color: Color(0xFF9ACD81)),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 14.0),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      color: SecondaryColor,
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            // CheckboxListTile - Seller
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() == true) {
                                  updatePassword();
                                } else {
                                  showToast(
                                      'Form is not valid. Please check the fields and select at least one role.');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: SecondaryColor, // Button color
                              ),
                              child: Text(
                                'Update',
                                style: TextStyle(color: textColor),
                              ),
                            ),
                            SizedBox(height: 10.0), // ElevatedButton
                          ], // Column children
                        ), // Column
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => login()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ))
            ],
          ),
        ],
      ))),
    );
  }
}
