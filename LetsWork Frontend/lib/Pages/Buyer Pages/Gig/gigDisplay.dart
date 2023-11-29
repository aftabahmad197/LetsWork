import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/Config/config.dart';

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
      final response = await http.get(Uri.parse(getGigs)); // Update to the appropriate API endpoint

      if (response.statusCode == 200) {
        final List<dynamic> jobList = jsonDecode(response.body);
        setState(() {
          gigs = jobList.cast<Map<String, dynamic>>();
        });
      } else {
        print('Failed to fetch jobs. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to fetch jobs. ${response.reasonPhrase}'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      print('Exception occurred while fetching jobs: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Exception occurred while fetching jobs. $e'),
        duration: Duration(seconds: 3),
      ));
    }
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
                        'Delivery time: ${gigs[index]['deliveryTime']}'),
                  ],
                ),
                onTap: () {
                  _showJobDetails(gigs[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showJobDetails(Map<String, dynamic> job) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobDetailsPage(job: job)),
    );
  }
}

class JobDetailsPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailsPage({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['title'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            SizedBox(height: 8.0),
            Text(job['description']),
            SizedBox(height: 8.0),
            Text('Budget: \$${job['price']}'),
            Text('Delivery time: ${job['deliveryTime']}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
