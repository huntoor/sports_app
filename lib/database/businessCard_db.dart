import 'package:sqflite/sqflite.dart';
import 'package:business_card/database/database_service.dart';
import 'package:business_card/model/businessCard.dart';


class BusinessCardDB {
  static const tableName = 'businessCard';

  static Future<void> createTable(Database database) async {
    const sql = """CREATE TABLE IF NOT EXISTS $tableName (
      "id" INTEGER NOT NULL,
      "name" TEXT NOT NULL,
      "companyName" TEXT NOT NULL,
      "email" TEXT NOT NULL,
      "mobileNumber" INTEGER NOT NULL,
      PRIMARY KEY("id" AUTOINCREMENT)
    );""";
    await database.execute(sql);
  }

  Future<int?> create({required String name, required String companyName, required String email, required int mobileNumber}) async {
    final database = await DatabaseService().database;
    return await database?.rawInsert(
      '''INSERT INTO $tableName (name, companyName, email, mobileNumber) VALUES (?,?,?,?)''',
      [name, companyName, email, mobileNumber],
    );
  }

  Future<List<BusinessCard>?> fetchAll() async {
    final database = await DatabaseService().database;
    final businessCards = await database?.rawQuery(
      '''SELECT * FROM $tableName'''
    );
    return businessCards?.map((businessCard) => BusinessCard.fromSqfliteDatabase(businessCard)).toList();
  }

  Future<BusinessCard> fetchById(int id) async {
    final database = await DatabaseService().database;
    final businessCard = await database?.rawQuery(
      '''SELECT * FROM $tableName WHERE id = ?''', [id]
    );
    return BusinessCard.fromSqfliteDatabase(businessCard!.first);
  }

  Future<int> update({required int id, String? name, String? companyName, String? email, int? mobileNumber}) async {
    final database = await DatabaseService().database;
    return await database!.update(
      tableName, 
      {
        if (name != null) 'name': name,
        if (companyName != null) 'companyName': companyName,
        if (email != null) 'email': email,
        if (mobileNumber != null) 'mobileNumber': mobileNumber,
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id]
      );
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database!.rawDelete(
      '''DELETE FROM $tableName WHERE id = ?''', [id]
    );
  }
}