import 'package:flutter/material.dart';
import 'add_screen.dart';
import 'edit_screen.dart';
import 'package:business_card/database/database_helper.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> sports = [];
  List<Map<String, dynamic>> filteredSports = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateSportList();
  }

  void updateSportList() async {
    sports = await databaseHelper.getAllSports();
    filterSports("");
  }

  void handleDelete(int id) async {
    await databaseHelper.deleteSport(id);
    updateSportList();
  }

  void filterSports(String query) {
    setState(() {
      filteredSports = sports
          .where((sport) =>
              sport['name'].toLowerCase().contains(query.toLowerCase()) ||
              sport['sport'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sports App'),
        backgroundColor:
            Color(0xFFe1811f), // Set the background color of the AppBar
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) => filterSports(query),
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSports.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(filteredSports[index]['name']),
                    subtitle: Text(filteredSports[index]['sport']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          handleDelete(filteredSports[index]['id']),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditScreen(
                              sport: filteredSports[index],
                              updateList: updateSportList),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddScreen(updateList: updateSportList),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(
            0xFFe1811f), // Set the background color of the FloatingActionButton
      ),
    );
  }
}
