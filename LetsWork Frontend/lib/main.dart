import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:frontend/Pages/User%20Authentication%20+%20Authorization/login.dart';
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