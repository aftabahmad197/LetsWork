import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../Config/config.dart';
import 'addJob.dart';
import 'editJob.dart';

class buyerJob extends StatefulWidget {
  final String? email;
  final int? balance;

  const buyerJob({Key? key, required this.email, required this.balance})
      : super(key: key);

  @override
  _buyerJobState createState() => _buyerJobState();
}

class _buyerJobState extends State<buyerJob> {
  List<Map<String, dynamic>> jobs = [];
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _getAllJobsByEmail(widget.email!);
  }

  //                          functions
  Future<void> _fetchCategories() async {
    try {
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
    } catch (e) {
      print('Exception occurred while fetching categories: $e');
    }
  }

  Future<void> _getAllJobsByEmail(String buyerEmail) async {
    try {
      final response = await http.get(Uri.parse(getjobbyemail + buyerEmail));

      if (response.statusCode == 200) {
        final List<dynamic> jobList = jsonDecode(response.body);
        setState(() {
          jobs = jobList
              .cast<Map<String, dynamic>>()
              .map((job) => {
                    ...job,
                    'deadline': DateTime.parse(job['deadline']),
                  })
              .toList();
        });
      } else {
        print('Failed to fetch jobs. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred while fetching jobs: $e');
    }
  }

  Future<void> _addJob(BuildContext context, String userId) async {
    final jobData = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddJobBottomSheet(
          categories: categories,
          onCategoryChanged: (String newValue) {},
        );
      },
    );

    if (jobData != null) {
      try {
        final response = await http.post(
          Uri.parse(addJob),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'title': jobData['title'],
            'description': jobData['description'],
            'category': jobData['category'],
            'buyer': userId,
            'budget': jobData['budget'],
            'deadline': DateFormat('yyyy-MM-dd').format(jobData['deadline']),
          }),
        );
        print(response.statusCode);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final job = jsonDecode(response.body);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              jobs.add(job);
            });
          });
        } else {
          print('Failed to add job. ${response.reasonPhrase}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to edit job. ${response.reasonPhrase}'),
            duration: Duration(seconds: 3),
          ));
        }
      } catch (e) {
        print('Exception occurred while adding job: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Exception occurred while adding job: $e'),
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  Future<void> _editJob(int index) async {
    final updatedJobData = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        print(jobs[index]);
        return EditJobBottomSheet(job: jobs[index], categories: categories);

      },
    );

    if (updatedJobData != null) {
      try {
        final response = await http.put(
          Uri.parse(updateJob + jobs[index]['_id']),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'title': updatedJobData['title'],
            'description': updatedJobData['description'],
            'category': updatedJobData['category'],
            'buyer': updatedJobData['buyer'],
            'budget': updatedJobData['budget'],
            'deadline': updatedJobData['deadline'],
          }),
        );

        if (response.statusCode == 200) {
          final editedJob = updatedJobData;
          setState(() {
            jobs[index] = editedJob;
          });
        } else {
          print('Failed to edit job. ${response.reasonPhrase}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to edit job. ${response.reasonPhrase}'),
            duration: Duration(seconds: 3),
          ));
        }
      } catch (e) {
        print('Exception occurred while editing job: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Exception occurred while editing job: $e'),
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  Future<void> _removeJob(int index) async {
    final jobId = jobs[index]['_id'];
    try {
      final response = await http.delete(
        Uri.parse(deleteJob +
            jobId), // Assuming deleteJob is the endpoint for deleting a job
      );

      if (response.statusCode == 200) {
        setState(() {
          jobs.removeAt(index);
        });
      } else {
        print('Failed to delete job. ${response.reasonPhrase}');
        // Handle the error as needed
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to delete job. ${response.reasonPhrase}'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      print('Exception occurred while deleting job: $e');
      // Handle the exception as needed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Exception occurred while deleting job: $e'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  //                          functions

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
                  return Dismissible(
                    key: Key(jobs[index]['_id']),
                    background: Container(
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16.0),
                    ),
                    onDismissed: (direction) {
                      _removeJob(index);
                    },
                    child: Card(
                      elevation: 5.0,
                      margin: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
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
                            Text('Budget: \$${jobs[index]['budget']}'),
                            Text(
                              'Deadline: ${DateFormat('yyyy-MM-dd').format(jobs[index]['deadline'])}',
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            _removeJob(index);
                          },
                        ),
                        onTap: () {
                          _editJob(index);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addJob(context, widget.email!);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
