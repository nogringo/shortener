import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortener/config.dart';
import 'package:shortener/pages/home/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shortener"),
        actions: [
          Obx(() {
            final isCreating = HomeController.to.isCreating.value;

            Widget icon = const Icon(Icons.create);
            if (isCreating) {
              icon = SizedBox(
                height: 20,
                width: 20,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }

            return FilledButton.icon(
              onPressed: isCreating ? null : HomeController.to.create,
              label: const Text("Create"),
              icon: icon,
            );
          }),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GetBuilder<HomeController>(
            builder: (c) {
              return Text("Preview: $baseUrl${c.key}/${c.authorPrefix}");
            },
          ),
          TextField(
            controller: HomeController.to.keyFieldController,
            onChanged: (_) => HomeController.to.update(),
          ),
          TextField(controller: HomeController.to.valueFieldController),
        ],
      ),
    );
  }
}
