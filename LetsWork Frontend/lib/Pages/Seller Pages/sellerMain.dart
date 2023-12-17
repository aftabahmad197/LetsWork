import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Pages/Seller%20Pages/Gig/sellergig.dart';
import 'package:frontend/Pages/Seller%20Pages/Job/jobDisplay.dart';
import 'package:frontend/Pages/Seller%20Pages/Profile/sellerProfile.dart';
import 'package:frontend/config/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import '../../Models/User.dart';
import '../../Theme/ColorTheme.dart';

class sellerMain extends StatefulWidget {
  final token;

  const sellerMain({@required this.token, Key? key}) : super(key: key);

  @override
  State<sellerMain> createState() => _sellerMainState();
}

class _sellerMainState extends State<sellerMain> {
  late User user;
  int _currentIndex = 0;
  late PageController _pageController =
      PageController(initialPage: _currentIndex);
      List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    Map<String, dynamic> userDecode = jwtDecodedToken['user'];
    user = User.fromJson(userDecode);
    _pageController = PageController(initialPage: _currentIndex);
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
          'profilePicture': user.profilePic,
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

  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse(getAllWhereBuyer + user.email!),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        if (responseData is List) {
          setState(() {
            notifications = responseData.cast<Map<String, dynamic>>();
          });
        } else {
          print('Expected a List, but received a ${responseData.runtimeType}.');
        }
      } else {
        print(
            'Failed to fetch notifications. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred while fetching notifications: $e');
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
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              // Using Builder to get a new context under the Scaffold
              return IconButton(
                icon: Icon(
                    Icons.notifications), // Change this to your desired icon
                onPressed: () {
                  fetchNotifications();
                  // Open the drawer using the new context
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.8, // Set the width as needed
          child: ListView(
            children: [
              DrawerHeader(
                child: Text(
                  'Notifications',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: mainColor,
                ),
              ),
              for (var notification in notifications)
                ListTile(
                  title: Text(
                    "Gig title: " + notification['title'].toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(" Buyer with this Email: " +
                      notification['buyer'].toString() +
                      ' purchased your gig!'),
                ),
            ],
          ),
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
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Gigs"),
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
          jobDisplay(email: user.email),
          sellerGig(email: user.email),
          sellerProfile(
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
                  user.profilePic = user.profilePic;
                });
                updateBackend(newFirstName, newLastName, newBalance);
              },
              onProfilePicUpdate: (newProfilePic) {
                setState(() {
                  user.profilePic = newProfilePic;
                });
              }),
        ],
      ),
    );
  }
}
