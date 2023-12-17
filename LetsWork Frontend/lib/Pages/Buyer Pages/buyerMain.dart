import 'dart:convert';
import 'package:frontend/Pages/Buyer%20Pages/Gig/gigDisplay.dart';
import 'package:frontend/Pages/Buyer%20Pages/Profile/buyerProfile.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config/config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
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

  List<Map<String, dynamic>> notifications = []; // Add this line
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

  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse(getalljobswhereSeller + user.email!),
      );
      final List<dynamic> jobList = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          notifications = jobList
              .cast<Map<String, dynamic>>()
              .map((job) => {
                    ...job,
                    'deadline': DateTime.parse(job['deadline']),
                  })
              .toList();
        });
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
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center Row contents horizontally,,
          children: [
            Text(
              "LetsWork",
              style: TextStyle(
                color: mainColor,
                fontSize: 35,
                fontFamily: "title",
              ),
            ),
            SizedBox(width: 10),
          ],
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
                    "Job title: " + notification['title'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(" Seller with this Email: " +
                      notification['Seller'] +
                      ' got your job'),
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
