import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbansensor/src/content/dashboard.dart';
import 'package:urbansensor/src/pages/projects_page.dart';
import 'package:urbansensor/src/providers/navigation_provider.dart';
import 'package:urbansensor/src/widgets/navigators/bottom_navigation_bar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(child: _contentPageSelected(context)),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {},
        child: const Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavigationBarC(),
    );
  }

  Widget _contentPageSelected(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    switch (navigationProvider.selectedIndex) {
      case 0:
        return const Dashboard();
      case 1:
        return const ProjectsPage();
      default:
        return const Dashboard();
    }
  }
}
