import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/config.dart';
import 'JobdetailsPage.dart';

class jobDisplay extends StatefulWidget {
  final String? email; // Receive user ID

  const jobDisplay({Key? key, required this.email}) : super(key: key);

  @override
  _jobDisplayState createState() => _jobDisplayState();
}

class _jobDisplayState extends State<jobDisplay> {
  List<Map<String, dynamic>> jobs = [];
  Future<void> _getAllJobs() async {
    try {
      final response = await http.get(Uri.parse(getalljobsExceptSeller + widget.email!)); // Update to the appropriate API endpoint

      if (response.statusCode == 200) {
        final List<dynamic> jobList = jsonDecode(response.body);
        setState(() {
          jobs = jobList.cast<Map<String, dynamic>>();
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
    _getAllJobs();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: jobs.isEmpty
            ? Center(
          child: Text('No jobs available.'),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5.0,
              margin:
              EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(
                  jobs[index]['title'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(jobs[index]['description']),
                    SizedBox(height: 8.0),
                    Text('Price: \$${jobs[index]['budget']}'),
                    Text(
                        'Deadline: ${jobs[index]['deadline']}'),
                  ],
                ),
                onTap: () {
                  _showJobDetails(jobs[index]);
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
      MaterialPageRoute(builder: (context) => JobDetailsPage(email: widget.email, job: job)),
    );
  }
}
