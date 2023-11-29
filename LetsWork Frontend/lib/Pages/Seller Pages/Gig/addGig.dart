import 'package:flutter/material.dart';

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