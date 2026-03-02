import 'package:ndk/ndk.dart';
import 'package:ndk/shared/nips/nip01/bip340.dart';
import 'package:nostr_shortener/src/config/default_relays.dart';
import 'package:nostr_shortener/src/functions/generate_key.dart';

Future<String> create({
  required String value,
  String? baseUrl = "https://nogringo.github.io/shortener/#/",
  String? key,
  String? type,
  int? keyLength,
  int? authorPrefixLength,
  String? nip05,
  Ndk? ndk,
  List<String>? relays,
}) async {
  authorPrefixLength ??= 4;

  final ndk0 =
      ndk ??
      Ndk(
        NdkConfig(
          eventVerifier: Bip340EventVerifier(),
          cache: MemCacheManager(),
          bootstrapRelays: [],
        ),
      );

  key ??= generateKey(length: keyLength);

  final keyPair = Bip340.generatePrivateKey();
  EventSigner signer = Bip340EventSigner(
    privateKey: keyPair.privateKey,
    publicKey: keyPair.publicKey,
  );

  final isLoggedIn = ndk0.accounts.isLoggedIn;
  if (isLoggedIn) {
    final ndkSigner = ndk0.accounts.getLoggedAccount()!.signer;
    if (ndkSigner.canSign()) {
      signer = ndkSigner;
    }
  }

  final event = Nip01Event(
    pubKey: signer.getPublicKey(),
    kind: 31994,
    tags: [
      ["d", key],
      if (type != null) ["type", type],
    ],
    content: value,
  );

  final signedEvent = await signer.sign(event);

  final broadcast = ndk0.broadcast.broadcast(
    nostrEvent: signedEvent,
    specificRelays: relays ?? defaultRelays,
  );

  await broadcast.broadcastDoneFuture;

  if (ndk == null) ndk0.destroy();

  String authorUrlPart;
  if (nip05 != null) {
    authorUrlPart = nip05;
  } else {
    authorUrlPart = signedEvent.pubKey.substring(0, authorPrefixLength);
  }

  return "$baseUrl$key/$authorUrlPart";
}
