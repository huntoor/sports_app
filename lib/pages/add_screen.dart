import 'package:flutter/material.dart';
import 'package:business_card/database/database_helper.dart';

class AddScreen extends StatefulWidget {
  final Function updateList;

  AddScreen({required this.updateList});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController sportController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();

  void handleAddSport() async {
    Map<String, dynamic> sport = {
      'name': nameController.text,
      'sport': sportController.text,
      'age': int.tryParse(ageController.text) ?? 0,
    };

    await databaseHelper.insertSport(sport);
    widget.updateList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Sport'),
        backgroundColor:
            Color(0xFFe1811f), // Set the background color of the AppBar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: sportController,
              decoration: InputDecoration(labelText: 'Sport'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: handleAddSport,
              child: Text('Add Sport'),
              style: ElevatedButton.styleFrom(
                primary:
                    Color(0xFFe1811f), // Set the background color of the button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
