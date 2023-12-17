import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../config/config.dart';

class GigDetailsPage extends StatefulWidget {
  final String? email;
  final Map<String, dynamic> job;

  const GigDetailsPage({Key? key, required this.email, required this.job}) : super(key: key);

  @override
  State<GigDetailsPage> createState() => _GigDetailsPageState();
}

class _GigDetailsPageState extends State<GigDetailsPage> {
  // Function to add buyer to the gig
  Future<void> _addBuyerToGig() async {
    try {
      var regBody = {"buyer": widget.email, "gig": widget.job['_id']};
      var response = await http.patch(
        Uri.parse(addBuyerToGigUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200) {
        print('Gig added successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gig added successfully.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        print('Failed to add gig. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add gig. ${response.reasonPhrase}'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Exception occurred while adding gig: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exception occurred while adding gig. $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gig Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title: " + widget.job['title'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              SizedBox(height: 8.0),
              Text("Description: " +widget.job['description']),
              SizedBox(height: 8.0),
              Text('Budget: \$${widget.job['price']}'),
              Text('Delivery time: ${widget.job['deliveryTime']}'),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: _addBuyerToGig,
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Button color
                ),
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Add more details as needed
            ],
          ),
        ),
      ),
    );
  }
}
