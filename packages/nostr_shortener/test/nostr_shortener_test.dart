import 'package:nostr_shortener/src/functions/create.dart';
import 'package:nostr_shortener/src/functions/resolve.dart';
import 'package:nostr_shortener/src/models/parsed_string.dart';
import 'package:test/test.dart';

void main() {
  test('First Test', () async {
    final originlaValue = "marmote";

    final link = await create(value: originlaValue);
    final resolvedValue = await resolve(source: link);

    expect(resolvedValue.first.value, originlaValue);
  });

  test('Second Test', () async {
    final originalKey = "8r99bb";
    final originalAuthorPrefix = "0e604fc7";

    final link =
        "https://nogringo.github.io/shortener/#/$originalKey/$originalAuthorPrefix";

    final parsed = ParsedString.fromSource(link);

    expect(parsed.key, originalKey);
    expect(parsed.authorPrefix, originalAuthorPrefix);
  });
}
