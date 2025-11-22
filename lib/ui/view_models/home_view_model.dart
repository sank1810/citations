import 'package:citations/data/citation_database.dart';
import 'package:citations/data/models/citation.dart';
import 'package:citations/ui/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends IHomeViewModel {
  final CitationDatabase _citationDatabase = CitationDatabase.instance;

  @override
  Future<List<Citation>> get citations async {
    return await _citationDatabase.loadCitations();
  }

  @override
  Future<bool> firstOpening() async {
    final prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool("first_time");
    if (firstTime == null) {
      prefs.setBool("first_time", false);
      return true;
    }
    return firstTime;
  }
}
