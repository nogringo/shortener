import 'package:flutter/material.dart';
import 'package:shortener/config.dart';
import 'package:shortener/routes/app_routes.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Resolving: $routeKey/$authorPrefix",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              "URL: $baseUrl$routeKey/$authorPrefix",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
