import 'dart:convert';
import 'package:citations/data/models/citation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class CitationDatabase {
  CitationDatabase._();

  static final CitationDatabase instance = CitationDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await createDatabase();
      return _database!;
    }
  }

  createDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'citations_database'),
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE citations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        citation TEXT,
        author TEXT,
        source TEXT
        )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertCitations(List citations) async {
    final Database db = await database;
    final batch = db.batch();

    for (var c in citations) {
      batch.insert('citations', c.toMap());
    }
    batch.commit(noResult: true);
  }

  Future<void> preloadDataIfFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyLoaded = prefs.getBool('citations_loaded') ?? false;

    if (alreadyLoaded == false) {
      final String str = await rootBundle.loadString('assets/citations.json');
      final List jsonList = jsonDecode(str);
      final List<Citation> citationList = jsonList
          .map((element) => Citation.fromJson(element))
          .toList();
      await insertCitations(citationList);
      prefs.setBool('citations_loaded', true);
    }
  }

  Future<List<Citation>> loadCitations() async {
    final Database db = await database;
    List citationsMap = await db.query('citations');
    List<Citation> citationsList = citationsMap
        .map((element) => Citation.fromJson(element))
        .toList();
    return citationsList;
  }
}
