import 'package:flutter/material.dart';
import 'package:shortener/pages/home/home_controller.dart';

class ResolveView extends StatelessWidget {
  const ResolveView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                "Resolve a Link",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: HomeController.to.linkFieldController,
            decoration: InputDecoration(hintText: "Shortened link here"),
            onSubmitted: (_) => HomeController.to.resolveLink(),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: HomeController.to.resolveLink,
            icon: const Icon(Icons.open_in_new),
            label: const Text("Resolve Link"),
            style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            margin: .zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "How to use",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Paste a shortener link to view its content. "
                    "The link should contain a key and author prefix.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
