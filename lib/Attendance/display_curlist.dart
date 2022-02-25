import 'package:flutter/material.dart';

class Select extends StatefulWidget {
  const Select({Key? key}) : super(key: key);

  @override
  _SelectState createState() => _SelectState();
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> l = [
    const DropdownMenuItem(
      child: Text("Chem"),
      value: "Chemical",
    ),
    const DropdownMenuItem(
      child: Text("IT"),
      value: "IT",
    ),
  ];
  return l;
}

class _SelectState extends State<Select> {
  String s = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DropdownButton(
              items: dropdownItems,
              value: s,
              onChanged: (String? nv) {
                setState(() {
                  s = nv!;
                });
              })
        ],
      ),
    );
  }
}
