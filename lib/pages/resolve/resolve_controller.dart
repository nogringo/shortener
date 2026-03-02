import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_shortener/nostr_shortener.dart';

class ResolveController extends GetxController {
  final String routeKey;
  final String authorPrefix;

  ResolveController({required this.routeKey, required this.authorPrefix});

  final RxList<ShortenedItem> items = <ShortenedItem>[].obs;
  final RxMap<String, Metadata?> metadataMap = <String, Metadata?>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMetadata = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    isLoading.value = true;
    hasError.value = false;
    items.clear();
    metadataMap.clear();

    try {
      final result = await Shortener.resolve(
        key: routeKey,
        authorPrefix: authorPrefix,
        ndk: Get.find<Ndk>(),
      );
      items.assignAll(result);

      // Fetch metadata for all authors
      await fetchMetadata(result.map((e) => e.author).toList());
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMetadata(List<String> pubKeys) async {
    if (pubKeys.isEmpty) return;

    isLoadingMetadata.value = true;

    try {
      final ndk = Get.find<Ndk>();
      final uniqueKeys = pubKeys.toSet().toList();

      for (var pubKey in uniqueKeys) {
        final profile = await ndk.metadata.loadMetadata(pubKey);
        metadataMap[pubKey] = profile;
      }
    } catch (e) {
      // Silently fail metadata loading - items will still show without names
    } finally {
      isLoadingMetadata.value = false;
    }
  }

  String getDisplayName(String pubKey) {
    final profile = metadataMap[pubKey];
    if (profile != null) {
      if (profile.displayName != null && profile.displayName!.isNotEmpty) {
        return profile.displayName!;
      }
      if (profile.name != null && profile.name!.isNotEmpty) {
        return profile.name!;
      }
    }
    // Fallback to anon_<first 8 chars after npub1>
    final npub = Nip19.encodePubKey(pubKey);
    final suffix = npub.substring(8, 16); // 8 chars after 'npub1'
    return 'anon_$suffix';
  }
}
