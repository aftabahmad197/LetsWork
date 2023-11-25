import 'package:flutter/material.dart';
import 'package:frontend/config/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../useful things/ColorTheme.dart';

late String firstName = "";
late String lastName = "";
late String email = "";
late int balance = 0;
late String profilePicture = "";
int _currentIndex = 0;
late PageController _pageController =
PageController(initialPage: _currentIndex);

class sellerHomePage extends StatefulWidget {
  final token;

  const sellerHomePage({@required this.token, Key? key}) : super(key: key);

  @override
  State<sellerHomePage> createState() => _sellerHomePageState();
}

class _sellerHomePageState extends State<sellerHomePage> {
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    Map<String, dynamic> user = jwtDecodedToken['user'];
    firstName = user['firstName'];
    lastName = user['lastName'];
    email = user['email'];
    balance = user['balance'];
    profilePicture = user['profilePic'];
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
          'email': email, // This should not be updated
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
          style:
          TextStyle(color: mainColor, fontSize: 35, fontFamily: "title"),
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
          HomePage(firstName: firstName),
          jobPostPage(),
          ProfilePage(
            firstName: firstName,
            lastName: lastName,
            email: email,
            balance: balance,
            onUpdate: (newFirstName, newLastName, newBalance) {
              setState(() {
                firstName = newFirstName;
                lastName = newLastName;
                balance = newBalance;
              });
              updateBackend(newFirstName, newLastName, newBalance);
            },
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String firstName;

  const HomePage({Key? key, required this.firstName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Hello, $firstName! This is the Home Page"));
  }
}

class jobPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("This is the job post Page"));
  }
}

class ProfilePage extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final int balance;
  final void Function(String, String, int) onUpdate;

  const ProfilePage({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.balance,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    TextEditingController _controllerFirstName =
    TextEditingController(text: firstName);
    TextEditingController _controllerLastName =
    TextEditingController(text: lastName);
    TextEditingController _controllerBalance =
    TextEditingController(text: balance.toString());

    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.black12,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: mainColor,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Text(
                          firstName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Balance $balance",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  selectedColor: Colors.white,
                  leading: Icon(Icons.account_circle,
                      size: 40.0, color: mainColor),
                  title: Text(
                    'Account Information',
                    style:
                    TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Tap to view details',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return AccountInfoBottomSheet(
                          firstName: firstName,
                          lastName: lastName,
                          email: email,
                          balance: balance,
                          controllerFirstName: _controllerFirstName,
                          controllerLastName: _controllerLastName,
                          controllerBalance: _controllerBalance,
                          onUpdate: onUpdate,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountInfoBottomSheet extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final int balance;
  final TextEditingController controllerFirstName;
  final TextEditingController controllerLastName;
  final TextEditingController controllerBalance;
  final void Function(String, String, int) onUpdate;

  const AccountInfoBottomSheet({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.balance,
    required this.controllerFirstName,
    required this.controllerLastName,
    required this.controllerBalance,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle, size: 60.0, color: mainColor),
              SizedBox(width: 16.0),
              Text(
                'Account Information',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          EditableField(
            label: 'First Name',
            value: firstName,
            isNumeric: false,
            controller: controllerFirstName,
          ),
          EditableField(
            label: 'Last Name',
            value: lastName,
            isNumeric: false,
            controller: controllerLastName,
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text(email),
          ),
          EditableField(
            label: 'Balance',
            value: balance.toString(),
            isNumeric: true,
            controller: controllerBalance,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              onUpdate(
                controllerFirstName.text,
                controllerLastName.text,
                int.parse(controllerBalance.text),
              );
              Navigator.pop(context); // Close the bottom sheet
            },
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}

class EditableField extends StatefulWidget {
  final String label;
  final String value;
  final bool isNumeric;
  final TextEditingController controller;

  const EditableField({
    Key? key,
    required this.label,
    required this.value,
    this.isNumeric = false,
    required this.controller,
  }) : super(key: key);

  @override
  _EditableFieldState createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.label),
      subtitle: _isEditing
          ? widget.isNumeric
          ? TextField(
        controller: widget.controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Enter ${widget.label}',
        ),
      )
          : TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: 'Enter ${widget.label}',
        ),
      )
          : Text(widget.value),
      trailing: _isEditing
          ? IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          setState(() {
            _isEditing = false;
          });
        },
      )
          : IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          setState(() {
            _isEditing = true;
          });
        },
      ),
    );
  }
}
