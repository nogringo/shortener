import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortener/pages/home/home_controller.dart';
import 'package:shortener/pages/home/views/create_view.dart';
import 'package:shortener/pages/home/views/resolve_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Get.put(HomeController());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shortener"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.add_link), text: "Create"),
            Tab(icon: Icon(Icons.open_in_new), text: "Resolve"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [CreateView(), ResolveView()],
      ),
    );
  }
}
