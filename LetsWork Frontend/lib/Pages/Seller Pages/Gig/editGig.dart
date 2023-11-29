import 'package:flutter/material.dart';

class EditGigBottomSheet extends StatefulWidget {
  final Map<String, dynamic> gig;
  final List<Map<String, dynamic>> categories;

  EditGigBottomSheet({required this.gig, required this.categories});

  @override
  _EditGigBottomSheetState createState() => _EditGigBottomSheetState();
}

class _EditGigBottomSheetState extends State<EditGigBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    titleController.text = widget.gig['title'];
    descriptionController.text = widget.gig['description'];
    priceController.text = widget.gig['price'].toString();
    deliveryTimeController.text = widget.gig['deliveryTime'].toString();
    selectedCategory = widget.gig['category'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Edit Gig',
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
              Navigator.pop(context, {
                'title': titleController.text,
                'description': descriptionController.text,
                'category': selectedCategory,
                'seller': widget.gig['seller'],
                'price': int.parse(priceController.text),
                'deliveryTime': int.parse(deliveryTimeController.text),
              });
            },
            child: Text('Save Changes'),
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


  void _saveChanges() {
    // Validate and save changes
    Map<String, dynamic> updatedGigData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'category': selectedCategory,
      'price': int.parse(priceController.text),
      'deliveryTime': int.parse(deliveryTimeController.text),
    };

    Navigator.pop(context, updatedGigData);
  }
}