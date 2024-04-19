import 'package:flutter/material.dart';
import 'package:payload_detecter/Providers/LoginProvider.dart';
import 'package:provider/provider.dart';

class DropDown extends StatefulWidget {
  const DropDown({super.key});

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String dropdownvalue = 'Admin';

  // List of items in our dropdown menu
  var items = [
    'Payloader',
    'Admin',
    'Contracter',
  ];
  @override
  Widget build(BuildContext context) {
    var loginProvider = Provider.of<LoginProvider>(context);
    return DropdownButton(
      // Initial Value
      value: dropdownvalue,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),

      onChanged: (String? newValue) {
        setState(() {
          dropdownvalue = newValue!;
          loginProvider.updateDropdownValue(newValue);
        });
      },
    );
  }
}
