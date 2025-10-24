class Citation {
  String citation;
  String author;
  String source;

  Citation({
    required this.citation,
    required this.author,
    required this.source,
  });

  factory Citation.fromJson(Map<String, dynamic> jsonCitation) {
    return Citation(
      citation: jsonCitation['citation'],
      author: jsonCitation['author'],
      source: jsonCitation['source'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'citation': citation, 'author': author, 'source': source};
  }
}
