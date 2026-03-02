import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:nostr_shortener/nostr_shortener.dart';
import 'package:shortener/routes/app_routes.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  TextEditingController keyFieldController = TextEditingController();
  TextEditingController valueFieldController = TextEditingController();

  final randomKey = Shortener.generateKey();

  RxBool isCreating = false.obs;

  String get key {
    if (keyFieldController.text.isEmpty) return randomKey;
    return keyFieldController.text;
  }

  String get authorPrefix =>
      Get.find<Ndk>().accounts.getPublicKey()!.substring(0, 4);

  Future<void> create() async {
    isCreating.value = true;

    await Shortener.create(value: valueFieldController.text);

    // Navigate to resolve page
    Get.toNamed(AppRoutes.resolveRoute(key: key, authorPrefix: authorPrefix));

    isCreating.value = false;
  }
}
