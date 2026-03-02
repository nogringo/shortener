import 'dart:math';

/// Generates a random key for shortened URLs.
///
/// [length] - Length of the generated key (default: 6)
/// [chars] - Character set to use (default: alphanumeric lowercase)
String generateKey({
  int? length,
  String chars = 'abcdefghjkmnpqrstuvwxyz23456789',
}) {
  length ??= 4;

  final random = Random.secure();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ),
  );
}
