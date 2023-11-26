class BusinessCard {
  final int id;

  final String name;
  final String companyName;
  final String email;
  final String mobileNumber;

  BusinessCard({
    required this.id,
    required this.name,
    required this.companyName,
    required this.email,
    required this.mobileNumber,
  });
  
  factory BusinessCard.fromSqfliteDatabase(Map<String, dynamic> map) => BusinessCard(
    id: map['id']?.toInt() >> 0,
    name: map['name'] ?? '',
    companyName: map['companyName'] ?? '', 
    email: map['email'] ?? '', 
    mobileNumber: map['mobileNumber'] ?? 0
  );
}
