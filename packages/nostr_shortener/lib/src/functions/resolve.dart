import 'package:ndk/ndk.dart';
import 'package:nostr_shortener/src/config/default_relays.dart';
import 'package:nostr_shortener/src/models/parsed_string.dart';
import 'package:nostr_shortener/src/models/shortened.dart';

Future<List<ShortenedItem>> resolve({
  String? source,
  String? key,
  String? authorPrefix,
  Ndk? ndk,
  List<String>? relays,
}) async {
  if (source != null) {
    final parsed = ParsedString.fromSource(source);
    key = parsed.key;
    authorPrefix = parsed.authorPrefix;
  }

  final ndk0 =
      ndk ??
      Ndk(
        NdkConfig(
          eventVerifier: Bip340EventVerifier(),
          cache: MemCacheManager(),
          bootstrapRelays: [],
        ),
      );

  final filter = Filter(kinds: [31994], dTags: [key!]);

  if (authorPrefix != null && authorPrefix.contains("@")) {
    final nip05 = await ndk0.nip05.resolve(authorPrefix);
    if (nip05 != null) {
      filter.authors = [nip05.pubKey];
      filter.limit = 1;
    }
  }

  final query = ndk0.requests.query(
    filter: filter,
    explicitRelays: relays ?? defaultRelays,
  );
  final events = await query.future;

  if (ndk == null) ndk0.destroy();

  List<ShortenedItem> items = [];
  for (var event in events) {
    try {
      items.add(ShortenedItem.fromEvent(event));
    } catch (e) {
      //
    }
  }

  if (items.length == 1) return items;

  if (authorPrefix != null && !authorPrefix.contains("@")) {
    items = items.where((e) => e.author.startsWith(authorPrefix!)).toList();
  }

  return items;
}
