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
          HomePage(firstName: firstName),
          gigPage(
            email: email,
          ),
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

class gigPage extends StatefulWidget {
  final String email; // Receive user ID

  const gigPage({Key? key, required this.email}) : super(key: key);

  @override
  _gigPageState createState() => _gigPageState();
}

class _gigPageState extends State<gigPage> {
  List<Map<String, dynamic>> gigs = [];
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _getAllGigsbyEmail(email);
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse(getCategories));
    print('Response Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> categoryList = jsonDecode(response.body);
      setState(() {
        categories = categoryList.cast<Map<String, dynamic>>();
      });
    } else {
      print('Failed to fetch categories. ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gigs'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: gigs.isEmpty
          ? Center(
        child: Text('No gigs available.'),
      )
          : ListView.builder(
        itemCount: gigs.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                gigs[index]['title'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gigs[index]['description']),
                  SizedBox(height: 8.0),
                  Text('Price: \$${gigs[index]['price']}'),
                  Text(
                      'Delivery Time: ${gigs[index]['deliveryTime']} days'),
                ],
              ),
              onTap: () {
                _editGig(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addGig(context, widget.email); // Pass user ID to _addGig
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _addGig(BuildContext context, String userId) async {
    final gigData = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddGigBottomSheet(
            categories: categories, onCategoryChanged: (String newValue) {});
      },
    );

    if (gigData != null) {
      final response = await http.post(
        Uri.parse(addGig),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': gigData['title'],
          'description': gigData['description'],
          'category': gigData['category'],
          'seller': userId, // Use user ID as the seller
          'price': gigData['price'],
          'deliveryTime': gigData['deliveryTime'],
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final gig = jsonDecode(response.body);
        setState(() {
          gigs.add(gig);
        });
      } else {
        print('Failed to add gig. ${response.reasonPhrase}');
      }
    }
  }

  Future<void> _editGig(int index) async {
    final updatedGigData = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EditGigBottomSheet(gig: gigs[index], categories: categories);
      },
    );

    if (updatedGigData != null) {
      final response = await http.put(
        Uri.parse(updateGig + gigs[index]['_id']),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': updatedGigData['title'],
          'description': updatedGigData['description'],
          'category': updatedGigData['category'],
          'seller': updatedGigData['seller'],
          'price': updatedGigData['price'],
          'deliveryTime': updatedGigData['deliveryTime'],
        }),
      );

      if (response.statusCode == 200) {
        final editedGig = jsonDecode(response.body);
        setState(() {
          gigs[index] = editedGig;
        });
      } else {
        print('Failed to edit gig. ${response.reasonPhrase}');
      }
    }
  }

  Future<void> _getAllGigsbyEmail(String sellerEmail) async {
    try {
      final response = await http.get(Uri.parse(getgigbyemail + sellerEmail));

      if (response.statusCode == 200) {
        final List<dynamic> gigList = jsonDecode(response.body);
        setState(() {
          gigs = gigList.cast<Map<String, dynamic>>();
        });
      } else {
        print('Failed to fetch gigs. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred while fetching gigs: $e');
    }
  }
}

class AddGigBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final Function(String) onCategoryChanged;

  AddGigBottomSheet(
      {required this.categories, required this.onCategoryChanged});

  @override
  _AddGigBottomSheetState createState() => _AddGigBottomSheetState();
}

class _AddGigBottomSheetState extends State<AddGigBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add a New Gig',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          buildCategoryDropdown(),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Price (\$)'),
          ),
          TextField(
            controller: deliveryTimeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Delivery Time (days)'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              print(selectedCategory);
              Navigator.pop(context, {
                'title': titleController.text,
                'description': descriptionController.text,
                'category': selectedCategory,
                'price': int.parse(priceController.text),
                'deliveryTime': int.parse(deliveryTimeController.text),
              });
            },
            child: Text('Add Gig'),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category'),
        SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: selectedCategory.isNotEmpty
              ? selectedCategory
              : widget.categories.isNotEmpty
              ? widget.categories[0]['name']
              : null,
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue!;
            });
            widget.onCategoryChanged(newValue!);
          },
          items: buildDropdownItems(widget.categories),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> buildDropdownItems(
      List<Map<String, dynamic>> categories) {
    List<DropdownMenuItem<String>> items = [];

    for (var category in categories) {
      items.add(DropdownMenuItem<String>(
        value: category['name'],
        child: Text(category['name']),
      ));

      if (category['subcategories'] != null) {
        items.addAll(buildDropdownItems(category['subcategories']));
      }
    }

    return items;
  }
}

class EditGigBottomSheet extends StatefulWidget {
  final Map<String, dynamic> gig;
  final List<Map<String, dynamic>> categories;

  EditGigBottomSheet({required this.gig, required this.categories});

  @override
  _EditGigBottomSheetState createState() => _EditGigBottomSheetState();
}

class _EditGigBottomSheetState extends State<EditGigBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    titleController.text = widget.gig['title'];
    descriptionController.text = widget.gig['description'];
    priceController.text = widget.gig['price'].toString();
    deliveryTimeController.text = widget.gig['deliveryTime'].toString();
    selectedCategory = widget.gig['category'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Edit Gig',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          buildCategoryDropdown(),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Price (\$)'),
          ),
          TextField(
            controller: deliveryTimeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Delivery Time (days)'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'title': titleController.text,
                'description': descriptionController.text,
                'category': selectedCategory,
                'seller': widget.gig['seller'],
                'price': int.parse(priceController.text),
                'deliveryTime': int.parse(deliveryTimeController.text),
              });
            },
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category'),
        SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: selectedCategory.isNotEmpty
              ? selectedCategory
              : widget.categories.isNotEmpty
              ? widget.categories[0]['name']
              : null,
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue!;
            });
          },
          items: buildDropdownItems(widget.categories),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> buildDropdownItems(
      List<Map<String, dynamic>> categories) {
    List<DropdownMenuItem<String>> items = [];

    for (var category in categories) {
      items.add(DropdownMenuItem<String>(
        value: category['name'],
        child: Text(category['name']),
      ));

      if (category['subcategories'] != null) {
        items.addAll(buildDropdownItems(category['subcategories']));
      }
    }

    return items;
  }


  void _saveChanges() {
    // Validate and save changes
    Map<String, dynamic> updatedGigData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'category': selectedCategory,
      'price': int.parse(priceController.text),
      'deliveryTime': int.parse(deliveryTimeController.text),
    };

    Navigator.pop(context, updatedGigData);
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
                              color: Color(0xffe6e0ea),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],

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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xffe6e0ea),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      selectedColor: Colors.white,
                      leading:
                          Icon(Icons.account_circle, size: 40.0, color: mainColor),
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
                  ),
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
