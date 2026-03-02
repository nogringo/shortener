enum ShortenedTypes { url, text, json }

class ShortenedItem {
  final String key;
  final String value;
  final ShortenedTypes? type;

  ShortenedItem({required this.key, required this.value, this.type});
}
