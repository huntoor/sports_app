import 'package:business_card/database/businessCard_db.dart';
import 'package:business_card/model/businessCard.dart';
import 'package:business_card/widget/create_businessCard_widget.dart';
import 'package:flutter/material.dart';

class BusinessCardPage extends StatefulWidget {
  const BusinessCardPage( { super.key } );

  @override
  State<BusinessCardPage> createState() => _BusinessCardPageState();

}

class _BusinessCardPageState extends State<BusinessCardPage> {
  late Future<List<BusinessCard>> futureBusinessCards;

  final businessCardDB = BusinessCardDB();

  @override
  void initState() {
    super.initState();

    fetchBusinessCards();

  }

  void fetchBusinessCards() {
    setState(() {
      futureBusinessCards = businessCardDB.fetchAll();
    });
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Business Cards"),
    ),
    body: FutureBuilder<List<BusinessCard>> (
      future: futureBusinessCards,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final businessCards = snapshot.data!;

          return businessCards.isEmpty ?
            const Center(
              child: Text(
                "No BusinessCards",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28
                ),
              ),
            ) 
            : ListView.separated(
              separatorBuilder: (context, index) => 
                const SizedBox(height: 12),
              itemCount: businessCards.length,
              itemBuilder: (context, index) {
                final businessCard = businessCards[index];
                final subtitle = businessCard.companyName;
                return ListTile(
                  title: Text(
                    businessCard.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(subtitle),
                  trailing: Row (
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await businessCardDB.delete(businessCard.id);
                          fetchBusinessCards();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => CreateBusinessCardWidget(
                              businessCard: businessCard,
                              onSubmit: (BusinessCard businessCard) async {
                                await businessCardDB.update(id: businessCard.id, name: businessCard.name, companyName: businessCard.companyName, email: businessCard.email, mobileNumber: int.parse(businessCard.mobileNumber));
                                if (!mounted) return;
                                fetchBusinessCards();
                                Navigator.of(context).pop();
                              }
                            )
                          );
                        },
                      ),
                    ],
                  )
                );
              },
            );

        }
      },
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => CreateBusinessCardWidget(
            onSubmit: (BusinessCard businessCard) async {
                await businessCardDB.create(name: businessCard.name, companyName: businessCard.companyName, email: businessCard.email, mobileNumber: int.parse(businessCard.mobileNumber));
                if (!mounted) return;
                fetchBusinessCards();
                Navigator.of(context).pop();
              }
          ),
        );
      },
    ),

  );
}