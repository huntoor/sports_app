import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SportFormPage(),
    );
  }
}

class SportFormPage extends StatefulWidget {
  @override
  _SportFormPageState createState() => _SportFormPageState();
}

class _SportFormPageState extends State<SportFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sportController = TextEditingController();

  late Future<Database> _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'sports_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE sports(id INTEGER PRIMARY KEY, name TEXT, age INTEGER, sport TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> _insertSport(String name, int age, String sport) async {
    final Database db = await _database;
    await db.insert(
      'sports',
      {
        'name': name,
        'age': age,
        'sport': sport,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sport Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sportController,
                decoration: InputDecoration(labelText: 'Sport'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the sport';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _insertSport(
                        _nameController.text,
                        int.parse(_ageController.text),
                        _sportController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sport added to the database')),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
