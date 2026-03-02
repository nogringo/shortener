import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortener/config.dart';
import 'package:shortener/routes/app_routes.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shortener"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilledButton(
              onPressed: AppRoutes.toHome,
              child: const Text("Create"),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
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
          );
        }

        if (controller.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  "No items found for $baseUrl$routeKey/$authorPrefix",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Key: $routeKey\nAuthor: $authorPrefix",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.value,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (item.type != null)
                      Chip(
                        label: Text(item.type!),
                        visualDensity: VisualDensity.compact,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      "Author: ${item.author.substring(0, 8)}...",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      "Key: ${item.key}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
