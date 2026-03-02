import 'package:ndk/ndk.dart';

class ShortenedItem {
  final String author;
  final String key;
  final String value;
  final String? type;

  ShortenedItem({
    required this.author,
    required this.key,
    required this.value,
    this.type,
  });

  /// Creates a [ShortenedItem] from a Nostr event (kind 31994).
  ///
  /// Event structure:
  /// ```json
  /// {
  ///   "kind": 31994,
  ///   "tags": [
  ///     ["d", "<key>"],
  ///     ["type", "<type>"]
  ///   ],
  ///   "content": "<value>"
  /// }
  /// ```
  factory ShortenedItem.fromEvent(Nip01Event event) {
    if (event.kind != 31994) {
      throw ArgumentError('Event kind must be 31994, got ${event.kind}');
    }

    final key = event.getDtag();

    if (key == null) {
      throw ArgumentError('D-tag should exist');
    }

    final typeTag = event.getFirstTag('type');

    return ShortenedItem(
      author: event.pubKey,
      key: key,
      value: event.content,
      type: typeTag,
    );
  }
}
