import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_shortener/nostr_shortener.dart';

class ResolveController extends GetxController {
  final String routeKey;
  final String authorPrefix;

  ResolveController({required this.routeKey, required this.authorPrefix});

  final RxList<ShortenedItem> items = <ShortenedItem>[].obs;
  final RxBool isLoading = false.obs;
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

    try {
      final result = await Shortener.resolve(
        key: routeKey,
        authorPrefix: authorPrefix,
        ndk: Get.find<Ndk>(),
      );
      items.assignAll(result);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
