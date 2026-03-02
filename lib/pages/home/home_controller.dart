import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_shortener/nostr_shortener.dart';
import 'package:shortener/routes/app_routes.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  TextEditingController keyFieldController = TextEditingController();
  TextEditingController valueFieldController = TextEditingController();
  TextEditingController linkFieldController = TextEditingController();

  final randomKey = Shortener.generateKey();

  RxBool isCreating = false.obs;
  RxBool isValueEmpty = true.obs;

  HomeController() {
    valueFieldController.addListener(() {
      isValueEmpty.value = valueFieldController.text.trim().isEmpty;
    });
  }

  String get key {
    if (keyFieldController.text.isEmpty) return randomKey;
    return keyFieldController.text;
  }

  String get authorPrefix =>
      Get.find<Ndk>().accounts.getPublicKey()!.substring(0, 4);

  Future<void> create() async {
    isCreating.value = true;

    await Shortener.create(
      key: key,
      value: valueFieldController.text,
      ndk: Get.find<Ndk>(),
    );

    // Navigate to resolve page
    Get.toNamed(AppRoutes.resolveRoute(key: key, authorPrefix: authorPrefix));

    isCreating.value = false;
  }

  void resolveLink() {
    final link = linkFieldController.text.trim();
    if (link.isEmpty) return;

    // Parse the link to extract key and authorPrefix
    // Expected format: https://.../#/key/authorPrefix or key/authorPrefix
    String? key;
    String? authorPrefix;

    try {
      final uri = Uri.tryParse(link);
      if (uri != null && uri.hasFragment) {
        final fragment = uri.fragment;
        if (fragment.startsWith('/')) {
          final parts = fragment.substring(1).split('/');
          if (parts.length >= 2) {
            key = parts[0];
            authorPrefix = parts[1];
          }
        }
      } else if (link.startsWith('/')) {
        final parts = link.substring(1).split('/');
        if (parts.length >= 2) {
          key = parts[0];
          authorPrefix = parts[1];
        }
      } else {
        final parts = link.split('/');
        if (parts.length >= 2) {
          key = parts[0];
          authorPrefix = parts[1];
        }
      }

      if (key != null && authorPrefix != null) {
        Get.toNamed(
          AppRoutes.resolveRoute(key: key, authorPrefix: authorPrefix),
        );
        linkFieldController.clear();
      } else {
        Get.snackbar(
          'Invalid link',
          'Please paste a valid shortener link (format: key/authorPrefix)',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to parse link: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
