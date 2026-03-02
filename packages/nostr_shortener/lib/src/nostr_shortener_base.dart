import 'functions/create.dart' as create_func;
import 'functions/resolve.dart' as resolve_func;
import 'functions/generate_key.dart' as generate_key_func;
import 'models/shortened.dart';
import 'package:ndk/ndk.dart';

/// Main API for the nostr_shortener package.
///
/// Provides static methods for creating and resolving shortened URLs.
class Shortener {
  /// Generates a random key for shortened URLs.
  ///
  /// [length] - Length of the generated key (default: 4)
  /// [chars] - Character set to use (default: alphanumeric lowercase without ambiguous chars)
  static String generateKey({
    int? length,
    String chars = 'abcdefghjkmnpqrstuvwxyz23456789',
  }) {
    return generate_key_func.generateKey(length: length, chars: chars);
  }

  /// Creates a new shortened URL entry on Nostr.
  ///
  /// [value] - The content/value to store (required)
  /// [baseUrl] - Base URL for the shortened link (default: "https://nogringo.github.io/shortener/#/")
  /// [key] - Custom key. If null, auto-generated using [generateKey]
  /// [type] - Optional type tag for the entry
  /// [keyLength] - Length of auto-generated key (default: 4)
  /// [authorPrefixLength] - Length of author prefix in URL (default: 4)
  /// [nip05] - Optional NIP-05 identifier to use instead of public key prefix
  /// [ndk] - Optional Ndk instance. If null, creates a temporary one
  /// [relays] - Optional list of specific relays to broadcast to
  static Future<String> create({
    required String value,
    String baseUrl = "https://nogringo.github.io/shortener/#/",
    String? key,
    String? type,
    int? keyLength,
    int? authorPrefixLength,
    String? nip05,
    Ndk? ndk,
    List<String>? relays,
  }) async {
    return await create_func.create(
      value: value,
      baseUrl: baseUrl,
      key: key,
      type: type,
      keyLength: keyLength,
      authorPrefixLength: authorPrefixLength,
      nip05: nip05,
      ndk: ndk,
      relays: relays,
    );
  }

  /// Resolves shortened URLs to their stored content.
  ///
  /// [source] - Full shortened URL (alternative to providing key/authorPrefix separately)
  /// [key] - The key part of the shortened URL
  /// [authorPrefix] - Author identifier (public key prefix or NIP-05)
  /// [ndk] - Optional Ndk instance. If null, creates a temporary one
  /// [relays] - Optional list of specific relays to query
  static Future<List<ShortenedItem>> resolve({
    String? source,
    String? key,
    String? authorPrefix,
    Ndk? ndk,
    List<String>? relays,
  }) async {
    return await resolve_func.resolve(
      source: source,
      key: key,
      authorPrefix: authorPrefix,
      ndk: ndk,
      relays: relays,
    );
  }
}
