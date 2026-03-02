import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ndk_flutter/ndk_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shortener/config.dart';
import 'package:shortener/widgets/responsive_layout.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import 'resolve_controller.dart';

class ResolvePage extends StatelessWidget {
  final String routeKey;
  final String authorPrefix;

  const ResolvePage({
    super.key,
    required this.routeKey,
    required this.authorPrefix,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ResolveController(routeKey: routeKey, authorPrefix: authorPrefix),
    );

    final link = "$baseUrl$routeKey/$authorPrefix";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shortener"),
        actions: [
          IconButton(
            onPressed: () {
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
            },
            icon: const Icon(Icons.copy),
            tooltip: "Copy link",
          ),
          IconButton(
            onPressed: () {
              SharePlus.instance.share(ShareParams(text: link));
            },
            icon: const Icon(Icons.share),
            tooltip: "Share link",
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: ConstrainedContent(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Error: ${controller.errorMessage.value}",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.items.isEmpty) {
          return Center(
            child: ConstrainedContent(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    "No items found",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              "$baseUrl$routeKey/$authorPrefix",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontFamily: 'monospace'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: link));

                              // Don't show toast on Android - OS already shows feedback
                              if (defaultTargetPlatform !=
                                  TargetPlatform.android) {
                                toastification.show(
                                  title: const Text('Copied'),
                                  description: const Text(
                                    'Link copied to clipboard',
                                  ),
                                  type: ToastificationType.success,
                                  style: ToastificationStyle.fillColored,
                                  autoCloseDuration: const Duration(seconds: 2),
                                  context: context,
                                );
                              }
                            },
                            icon: const Icon(Icons.copy),
                            tooltip: "Copy link",
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Key: $routeKey\nAuthor: $authorPrefix",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                final item = controller.items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final uri = Uri.tryParse(item.value);
                                  if (uri != null && await canLaunchUrl(uri)) {
                                    await launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                                child: SelectableText(
                                  item.value,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: item.value),
                                );

                                // Don't show toast on Android - OS already shows feedback
                                if (defaultTargetPlatform !=
                                    TargetPlatform.android) {
                                  toastification.show(
                                    title: const Text('Copied'),
                                    description: const Text(
                                      'Value copied to clipboard',
                                    ),
                                    type: ToastificationType.success,
                                    style: ToastificationStyle.fillColored,
                                    autoCloseDuration: const Duration(
                                      seconds: 2,
                                    ),
                                    context: context,
                                  );
                                }
                              },
                              icon: const Icon(Icons.copy),
                              tooltip: "Copy value",
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (item.type != null)
                          Chip(
                            label: Text(item.type!),
                            visualDensity: VisualDensity.compact,
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            NPicture(
                              ndkFlutter: Get.find(),
                              pubkey: item.author,
                              circleAvatarRadius: 12,
                            ),
                            SizedBox(width: 8),
                            Obx(
                              () => Text(
                                controller.getDisplayName(item.author),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
