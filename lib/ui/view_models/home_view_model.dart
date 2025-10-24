import 'package:citations/data/citation_database.dart';
import 'package:citations/data/models/citation.dart';
import 'package:citations/ui/views/home_screen.dart';

class HomeViewModel extends IHomeViewModel {
  final CitationDatabase _citationDatabase = CitationDatabase.instance;

  @override
  Future<List<Citation>> get citations async {
    return await _citationDatabase.loadCitations();
  }
}
