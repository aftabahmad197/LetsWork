// ignore_for_file: camel_case_types, library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors, use_super_parameters, file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:frontend/Pages/Buyer%20Pages/Gig/gigDetailDisplayPage.dart';
import 'package:frontend/config/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class gigDisplay extends StatefulWidget {
  final String? email; // Receive user ID

  const gigDisplay({Key? key, required this.email}) : super(key: key);

  @override
  _gigDisplayState createState() => _gigDisplayState();
}

class _gigDisplayState extends State<gigDisplay> {
  List<Map<String, dynamic>> gigs = [];

  Future<void> _getAllGigs() async {
    try {
      final response = await http.get(Uri.parse(getAllExceptBuyer + widget.email!)); // Update to the appropriate API endpoint

      if (response.statusCode == 200) {
        final List<dynamic> jobList = jsonDecode(response.body);
        setState(() {
          gigs = jobList.cast<Map<String, dynamic>>();
        });
      } else {
        print('Failed to fetch Gigs. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch Gigs. ${response.reasonPhrase}'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      print('Exception occurred while fetching Gigs: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Exception occurred while fetching Gigs. $e'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  void _showGigDetails(Map<String, dynamic> job) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GigDetailsPage(email: widget.email ,job: job)),
    );
  }

  @override
  void initState() {
    super.initState();
    _getAllGigs();
  }

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
                child: Text('No Gigs available.'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: gigs.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                        "Title: " + gigs[index]['title'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text("Description: " + gigs[index]['description']),
                          SizedBox(height: 8.0),
                          Text('Price: \$${gigs[index]['price']}'),
                          Text('Delivery time: ${gigs[index]['deliveryTime']}'),
                        ],
                      ),
                      onTap: () {
                        _showGigDetails(gigs[index]);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}


