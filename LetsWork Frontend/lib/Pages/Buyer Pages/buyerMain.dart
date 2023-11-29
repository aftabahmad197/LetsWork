import 'dart:convert';
import 'package:frontend/Pages/Buyer%20Pages/Gig/gigDisplay.dart';
import 'package:frontend/Pages/Buyer%20Pages/Profile/buyerProfile.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import '../../Config/config.dart';
import '../../Models/User.dart';
import '../../Theme/ColorTheme.dart';
import 'Job/buyerJob.dart';

class buyerMain extends StatefulWidget {
  final token;

  const buyerMain({@required this.token, Key? key}) : super(key: key);

  @override
  State<buyerMain> createState() => _buyerMainState();
}

class _buyerMainState extends State<buyerMain> {
  //                     Variables
  late User user;
  int _currentIndex = 0;
  late PageController _pageController =
      PageController(initialPage: _currentIndex);

  //                     Variables

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    Map<String, dynamic> userDecode = jwtDecodedToken['user'];
    user = User.fromJson(userDecode);
  }

  Future<void> updateBackend(
      String newFirstName, String newLastName, int newBalance) async {
    try {
      final response = await http.put(
        Uri.parse(updateUser),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': newFirstName,
          'lastName': newLastName,
          'email': user.email, // This should not be updated
          'balance': newBalance,
        }),
      );

      if (response.statusCode == 200) {
        print('Backend update successful');
      } else {
        print('Failed to update backend. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred while updating backend: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "LetsWork",
          style: TextStyle(color: mainColor, fontSize: 35, fontFamily: "title"),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mainColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Jobs"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          gigDisplay(email: user.email),
          buyerJob(
            email: user.email,
            balance: user.balance,
          ),
          buyerProfile(
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            balance: user.balance,
            profilePic: user.profilePic,
            onUpdate: (newFirstName, newLastName, newBalance) {
              setState(() {
                user.firstName = newFirstName;
                user.lastName = newLastName;
                user.balance = newBalance;
              });
              updateBackend(newFirstName, newLastName, newBalance);
            },
          ),
        ],
      ),
    );
  }
}
