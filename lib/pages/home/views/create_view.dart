import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortener/config.dart';
import 'package:shortener/pages/home/home_controller.dart';

class CreateView extends StatelessWidget {
  const CreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.text_fields,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text("Long Text", style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: HomeController.to.valueFieldController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "Enter the URL or text to shorten",
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.tag, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text("Short Key", style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: HomeController.to.keyFieldController,
            onChanged: (_) => HomeController.to.update(),
            decoration: InputDecoration(hintText: HomeController.to.randomKey),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.link, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                "Your Short Link",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          GetBuilder<HomeController>(
            builder: (c) {
              final link = "$baseUrl${c.key}/${c.authorPrefix}";
              return Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                margin: .zero,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          link,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontFamily: 'monospace'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () =>
                            HomeController.to.copyLink(link, context: context),
                        icon: const Icon(Icons.copy),
                        tooltip: "Copy link",
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Obx(() {
            final isCreating = HomeController.to.isCreating.value;
            final isDisabled = HomeController.to.isValueEmpty.value;
            return FilledButton.icon(
              onPressed: isCreating || isDisabled
                  ? null
                  : HomeController.to.create,
              icon: isCreating
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_link),
              label: Text(isCreating ? "Creating..." : "Create Short Link"),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            );
          }),
        ],
      ),
    );
  }
}
