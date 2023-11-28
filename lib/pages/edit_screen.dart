import 'package:flutter/material.dart';
import 'package:sports_app/database/database_helper.dart';

class EditScreen extends StatefulWidget {
  final Map<String, dynamic> sport;
  final Function updateList;

  EditScreen({required this.sport, required this.updateList});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController sportController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.sport['name'];
    sportController.text = widget.sport['sport'];
    ageController.text = widget.sport['age'].toString();
  }

  void handleEditSport() async {
    Map<String, dynamic> updatedSport = {
      'id': widget.sport['id'],
      'name': nameController.text,
      'sport': sportController.text,
      'age': int.tryParse(ageController.text) ?? 0,
    };

    await databaseHelper.updateSport(updatedSport);
    widget.updateList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Sport'),
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
              onPressed: handleEditSport,
              child: Text('Edit Sport'),
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
