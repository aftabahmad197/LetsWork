import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Pages/Forget%20Password/findUser.dart';
import 'package:frontend/Pages/buyerHomePage.dart';
import 'package:frontend/Pages/sellerHomePage.dart';
import 'package:frontend/Pages/signup.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  //                     Variables
  Color mainColor = Color(0xff236F14);
  Color SecondaryColor = Color(0xFF29D924);
  Color textColor = Colors.white;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _lowercaseEmail = '';
  bool _obscurePassword = true;
  late SharedPreferences prefs;

  //                     Variables
  //                     functions

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  void loginUser() async {
    var regbody = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };
    var response = await http.post(Uri.parse(loginU),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regbody));
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // User successfully registered
      var myToken = jsonResponse['token'];
      prefs.setString('token', myToken);
      print("Login Successful");
      showToast("Registration Successful");
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
      Map<String, dynamic> user = jwtDecodedToken['user'];
      String loginRole = user["role"];
      if(loginRole == "Buyer")
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => buyerHomePage(token: myToken)),
          );
        }
      else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => sellerHomePage(token: myToken)),
        );
      }
      print(user);
    } else {
      // Registration failed
      print("Login Failed. Please try again.");
      String errorMessage = jsonResponse['message'] ?? 'Unknown error';
      showToast("Registration Failed. $errorMessage. Please try again.");
    }
  }

  //                     functions
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
                            SizedBox(height: 10.0),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => findUser()),
                                  );
                                },
                                child: Text(
                                  'forgot password?',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                )),
                            SizedBox(height: 10.0),
                            // CheckboxListTile - Seller
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() == true) {
                                  loginUser();
                                } else {
                                  print(
                                      'Form is not valid. Please check the fields.');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: SecondaryColor, // Button color
                              ),
                              child: Text(
                                'Login',
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
                      MaterialPageRoute(builder: (context) => signup()),
                    );
                  },
                  child: Text(
                    'Sign Up',
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
