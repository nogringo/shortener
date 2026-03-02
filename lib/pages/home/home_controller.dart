import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_shortener/nostr_shortener.dart';
import 'package:shortener/routes/app_routes.dart';
import 'package:toastification/toastification.dart';

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
        toastification.show(
          title: const Text('Invalid link'),
          description: Text(
            'Please paste a valid shortener link (format: key/authorPrefix)',
          ),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      toastification.show(
        title: const Text('Error'),
        description: Text('Failed to parse link: $e'),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  void copyLink(String link, {required BuildContext context}) {
    Clipboard.setData(ClipboardData(text: link));

    // Don't show toast on Android - OS already shows feedback
    if (defaultTargetPlatform != TargetPlatform.android) {
      toastification.show(
        title: const Text('Copied'),
        description: const Text('Link copied to clipboard'),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 2),
        context: context,
      );
    }
  }
}
