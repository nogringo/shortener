import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:ndk/shared/nips/nip01/bip340.dart';
import 'package:ndk_flutter/ndk_flutter.dart';
import 'package:shortener/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ndk = Ndk(
    NdkConfig(
      eventVerifier: kIsWeb ? WebEventVerifier() : Bip340EventVerifier(),
      cache: MemCacheManager(),
    ),
  );

  final ndkFlutter = NdkFlutter(ndk: ndk);

  await ndkFlutter.restoreAccountsState();

  if (ndk.accounts.isNotLoggedIn) {
    final keyPair = Bip340.generatePrivateKey();
    ndk.accounts.loginPrivateKey(
      pubkey: keyPair.publicKey,
      privkey: keyPair.privateKey!,
    );

    await ndkFlutter.saveAccountsState();
  }

  Get.put(ndk);
  Get.put(ndkFlutter);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.pages,
    );
  }
}
