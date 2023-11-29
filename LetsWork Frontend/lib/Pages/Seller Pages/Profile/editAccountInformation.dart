import 'package:flutter/material.dart';
class EditableField extends StatefulWidget {
  final String label;
  final String value;
  final bool isNumeric;
  final TextEditingController controller;

  const EditableField({
    Key? key,
    required this.label,
    required this.value,
    this.isNumeric = false,
    required this.controller,
  }) : super(key: key);

  @override
  _EditableFieldState createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.label),
      subtitle: _isEditing
          ? widget.isNumeric
          ? TextField(
        controller: widget.controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Enter ${widget.label}',
        ),
      )
          : TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: 'Enter ${widget.label}',
        ),
      )
          : Text(widget.value),
      trailing: _isEditing
          ? IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          setState(() {
            _isEditing = false;
          });
        },
      )
          : IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          setState(() {
            _isEditing = true;
          });
        },
      ),
    );
  }
}