import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AddJobBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final Function(String) onCategoryChanged;

  AddJobBottomSheet(
      {required this.categories, required this.onCategoryChanged});

  @override
  _AddJobBottomSheetState createState() => _AddJobBottomSheetState();
}

class _AddJobBottomSheetState extends State<AddJobBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  String selectedCategory = '';
  DateTime? selectedDate;

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
              'Add a New Job',
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
                if (selectedDate == null) {
                  // Show a warning or prompt user to select a date.
                  return;
                }

                if (selectedDate!.isBefore(DateTime.now())) {
                  // Show a warning or prompt user to select a future date.
                  return;
                }

                print(selectedCategory);
                Navigator.pop(context, {
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'category': selectedCategory,
                  'budget': int.parse(budgetController.text),
                  'deadline': selectedDate,
                });
              },
              child: Text('Add Job'),
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
            widget.onCategoryChanged(newValue!);
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
              initialDate: DateTime.now(),
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
            selectedDate != null
                ? 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'
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