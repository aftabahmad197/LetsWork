import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/Config/config.dart';

import 'addGig.dart';
import 'editGig.dart';

class sellerGig extends StatefulWidget {
  final String? email; // Receive user ID

  const sellerGig({Key? key, required this.email}) : super(key: key);

  @override
  _sellerGigState createState() => _sellerGigState();
}

class _sellerGigState extends State<sellerGig> {
  List<Map<String, dynamic>> gigs = [];
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _getAllGigsbyEmail(widget.email!);
  }

  //                      functions
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch categories. ${response.reasonPhrase}'),
        duration: Duration(seconds: 3),
      ));
    }
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add gig. ${response.reasonPhrase}'),
          duration: Duration(seconds: 3),
        ));
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to edit gig. ${response.reasonPhrase}'),
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  Future<void> _removeGig(int index) async {
    final response = await http.delete(Uri.parse(deleteGig + gigs[index]['_id']));

    if (response.statusCode == 200) {
      setState(() {
        gigs.removeAt(index);
      });
    } else {
      print('Failed to delete gig. ${response.reasonPhrase}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete gig. ${response.reasonPhrase}'),
        duration: Duration(seconds: 3),
      ));
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch gigs. ${response.reasonPhrase}'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      print('Exception occurred while fetching gigs: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Exception occurred while fetching gigs. $e'),
        duration: Duration(seconds: 3),
      ));
    }
  }
  //                      functions


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gigs'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: gigs.isEmpty
            ? Center(
          child: Text('No gigs available.'),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: gigs.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(gigs[index]['_id']),
              background: Container(
                color: Colors.red,
                child: Icon(Icons.delete, color: Colors.white),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 16.0),
              ),
              onDismissed: (direction) {
                _removeGig(index);
              },
              child: Card(
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
                  trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      _removeGig(index);
                    },
                  ),
                  onTap: () {
                    _editGig(index);
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addGig(context, widget.email!); // Pass user ID to _addGig
        },
        child: Icon(Icons.add),
      ),
    );
  }


}