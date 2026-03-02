import 'package:ndk/ndk.dart';
import 'package:nostr_shortener/src/models/shortened.dart';

/// [source] Should end by /{key}/{author}
Future<List<ShortenedItem>> resolve({
  required String key,
  String? authorPrefix,
  Ndk? ndk,
}) async {
  final _ndk =
      ndk ??
      Ndk(
        NdkConfig(
          eventVerifier: Bip340EventVerifier(),
          cache: MemCacheManager(),
          bootstrapRelays: [],
        ),
      );

  final query = _ndk.requests.query(
    filter: Filter(kinds: [31994], dTags: [key]),
  );

  final events = query.future;

  
}
