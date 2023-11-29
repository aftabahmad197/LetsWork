import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/Pages/Forget%20Password/resetPassword.dart';
import 'package:frontend/Pages/User%20Authentication%20+%20Authorization/login.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';

class findUser extends StatefulWidget {
  const findUser({super.key});

  @override
  State<findUser> createState() => _findUserState();
}

class _findUserState extends State<findUser> {
  //                     Variables
  Color mainColor = Color(0xff236F14);
  Color SecondaryColor = Color(0xFF29D924);
  Color textColor = Colors.white;
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _lowercaseEmail = '';

  //                     Variables

  //                     function

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  void find() async {
    var regbody = {
      "email": _emailController.text,
    };
    var response = await http.post(
      Uri.parse(findUserU),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regbody),
    );

    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      showToast("User found Successfully");

      // Pass the email data to the next page using the constructor
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => resetPassword(email: _emailController.text)),
      );
    } else {
      String errorMessage = jsonResponse['message'] ?? 'Unknown error';
      showToast("Error: $errorMessage. Please try again.");
    }
  }

  //                     function
  @override
  Widget build(BuildContext context) {
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
                width: 300,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(
                      20.0), // Adjust the radius as needed
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Log In',
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
                              controller: _emailController,
                              onChanged: (value) {
                                setState(() {
                                  // Convert the entered email to lowercase and update the variable
                                  _lowercaseEmail = value.toLowerCase();
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(
                                        r'^[a-zA-Z0-9._%+-]+@(gmail\.com|outlook\.com)$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address.';
                                }
                                // You can add more advanced email validation logic here if needed
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(color: Color(0xFF9ACD81)),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 14.0),
                              ),
                            ),
                            // TextFormField - Email

                            SizedBox(height: 10.0),

                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() == true) {
                                  find();
                                } else {
                                  showToast(
                                      'Form is not valid. Please check the fields and select at least one role.');
                                  print(
                                      'Form is not valid. Please check the fields and select at least one role.');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: SecondaryColor, // Button color
                              ),
                              child: Text(
                                'Find',
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
                    'Log In',
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
