class ParsedString {
  String key;
  String authorPrefix;

  ParsedString({required this.key, required this.authorPrefix});

  /// Parses a shortened URL to extract key and optional author.
  ///
  /// [source] - The URL to parse (can be full URL or just path)
  factory ParsedString.fromSource(String source) {
    final parts = source.split('/');

    String authorPrefix = parts.last;
    String key = parts[parts.length - 2];

    return ParsedString(key: key, authorPrefix: authorPrefix);
  }
}
