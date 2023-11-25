import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:frontend/Pages/Forget%20Password/findUser.dart';
import 'package:frontend/Pages/buyerHomePage.dart';
import 'package:frontend/Pages/login.dart';
import 'package:frontend/Pages/signup.dart';
void main() => runApp(
  DevicePreview(
  builder: (context) => MyApp(),
),);
class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LetsWork',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: login(),
    );
  }
}