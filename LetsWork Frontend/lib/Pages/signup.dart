import 'dart:convert';
import 'package:frontend/Pages/login.dart';
import 'package:frontend/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  //                     Variables
  Color mainColor = Color(0xff236F14);
  Color SecondaryColor = Color(0xFF29D924);
  Color textColor = Colors.white;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isBuyerChecked = false;
  bool _isSellerChecked = false;
  bool _obscurePassword = true; // Controls password visibility
  bool _obscureConfirmPassword = true; // Controls confirm password visibility
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

  void registerUser() async {
    String role = "";
    if (_isBuyerChecked) {
      role = "Buyer";
    } else {
      role = "Seller";
    }

    if (role.isNotEmpty) {
      var regbody = {
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "role": role
      };
      var response = await http.post(Uri.parse(register),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regbody));

      if (response.statusCode == 200) {
        // User successfully registered
        print("Registration Successful");
        showToast("Registration Successful");
      } else {
        // Registration failed
        print("Registration Failed. Please try again.");
        showToast("Registration Failed. Please try again.");
      }
    }
  }

  //                     function
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
                              controller: _firstNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your first name',
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
                            // TextFormField - First Name

                            SizedBox(height: 10.0),

                            TextFormField(
                              controller: _lastNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your last name',
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
                            // TextFormField - Last Name

                            SizedBox(height: 10.0),

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
                            CheckboxListTile(
                              title: Text(
                                'Buyer',
                                style: TextStyle(
                                    color: Colors.white), // Text color
                              ),
                              value: _isBuyerChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isBuyerChecked = value!;
                                  if (_isBuyerChecked) {
                                    _isSellerChecked = false;
                                  }
                                });
                              },
                              activeColor: Color(0xFF29D924), // Checkbox color
                            ),
                            // CheckboxListTile - Buyer

                            CheckboxListTile(
                              title: Text(
                                'Seller',
                                style: TextStyle(
                                    color: Colors.white), // Text color
                              ),
                              value: _isSellerChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isSellerChecked = value!;
                                  if (_isSellerChecked) {
                                    _isBuyerChecked = false;
                                  }
                                });
                              },
                              activeColor: Color(0xFF29D924), // Checkbox color
                            ),
                            SizedBox(height: 10.0),
                            // CheckboxListTile - Seller
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() == true &&
                                    (_isBuyerChecked || _isSellerChecked)) {
                                  registerUser();
                                } else {
                                  showToast(
                                      'Form is not valid. Please check the fields and select at least one role.');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: SecondaryColor, // Button color
                              ),
                              child: Text(
                                'Register',
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
