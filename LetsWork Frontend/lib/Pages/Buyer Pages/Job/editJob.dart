import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditJobBottomSheet extends StatefulWidget {
  final Map<String, dynamic> job;
  final List<Map<String, dynamic>> categories;

  EditJobBottomSheet({required this.job, required this.categories});

  @override
  _EditJobBottomSheetState createState() => _EditJobBottomSheetState();
}

class _EditJobBottomSheetState extends State<EditJobBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  String selectedCategory = '';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.job['title'];
    descriptionController.text = widget.job['description'];
    budgetController.text = widget.job['budget'].toString();

    if (widget.job['deadline'] == DateTime.now()) {
      selectedDate = widget.job['deadline'];
    }

    selectedCategory = widget.job['category'];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Job',
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
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Budget (\$)'),
            ),
            buildDateSelector(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'category': selectedCategory,
                  'buyer': widget.job['buyer'],
                  'budget': int.parse(budgetController.text),
                  'deadline': DateFormat('yyyy-MM-dd').format(selectedDate),
                });
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
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

  Widget buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Deadline'),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null && pickedDate != selectedDate) {
              setState(() {
                selectedDate = pickedDate;
              });
            }
          },
          child: Text(
            // ignore: unnecessary_null_comparison
            selectedDate != null
                ? 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'
                : 'Select Date',
          ),
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