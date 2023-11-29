import 'package:flutter/material.dart';

import '../../../Theme/ColorTheme.dart';
import 'editAccountInformation.dart';
class AccountInfoBottomSheet extends StatelessWidget {
  final String? firstName;
  final String? lastName;
  final String? email;
  final int? balance;
  final TextEditingController controllerFirstName;
  final TextEditingController controllerLastName;
  final TextEditingController controllerBalance;
  final void Function(String, String, int) onUpdate;

  const AccountInfoBottomSheet({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.balance,

    required this.controllerFirstName,
    required this.controllerLastName,
    required this.controllerBalance,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle, size: 60.0, color: mainColor),
              SizedBox(width: 16.0),
              Text(
                'Account Information',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          EditableField(
            label: 'First Name',
            value: firstName!,
            isNumeric: false,
            controller: controllerFirstName,
          ),
          EditableField(
            label: 'Last Name',
            value: lastName!,
            isNumeric: false,
            controller: controllerLastName,
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text(email!),
          ),
          EditableField(
            label: 'Balance',
            value: balance.toString(),
            isNumeric: true,
            controller: controllerBalance,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              onUpdate(
                controllerFirstName.text,
                controllerLastName.text,
                int.parse(controllerBalance.text),
              );
              Navigator.pop(context); // Close the bottom sheet
            },
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}