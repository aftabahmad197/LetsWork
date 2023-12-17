
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../../config/config.dart';

class JobDetailsPage extends StatefulWidget {
  final String? email;
  final Map<String, dynamic> job;

  const JobDetailsPage({Key? key, required this.email, required this.job}) : super(key: key);

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  // Function to add seller to the gig
  Future<void> _addSellerToGig() async {
    try {
      var regBody = {"seller": widget.email};
      var response = await http.patch(
        Uri.parse(addSellerToJobUrl + widget.job['_id']),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200) {
        print('Job added successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Job added successfully.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        print('Failed to add job. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add job. ${response.reasonPhrase}'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Exception occurred while adding job: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exception occurred while adding job. $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.job['title'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              SizedBox(height: 8.0),
              Text(widget.job['description']),
              SizedBox(height: 8.0),
              Text('Budget: \$${widget.job['budget']}'),
              Text('Deadline: ${widget.job['deadline']}'),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: _addSellerToGig,
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
