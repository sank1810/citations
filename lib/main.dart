import 'package:citations/data/citation_database.dart';
import 'package:citations/ui/view_models/home_view_model.dart';
import 'package:citations/ui/views/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CitationDatabase.instance.preloadDataIfFirstLaunch();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'citations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(HomeViewModel()),
    );
  }
}
