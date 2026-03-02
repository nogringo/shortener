import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortener/pages/home/home_controller.dart';
import 'package:shortener/pages/home/views/create_view.dart';
import 'package:shortener/pages/home/views/resolve_view.dart';
import 'package:shortener/widgets/responsive_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

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

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
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

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            extended: true,
            leading: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  "Shortener",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
              ],
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.add_link),
                label: Text("Create"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.open_in_new),
                label: Text("Resolve"),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [CreateView(), ResolveView()],
            ),
          ),
        ],
      ),
    );
  }
}
