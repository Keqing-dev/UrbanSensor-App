import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/content/dashboard.dart';
import 'package:urbansensor/src/pages/menu_page.dart';
import 'package:urbansensor/src/pages/projects_page.dart';
import 'package:urbansensor/src/providers/navigation_provider.dart';
import 'package:urbansensor/src/widgets/capture_image.dart';
import 'package:urbansensor/src/widgets/expandable_fab.dart';
import 'package:urbansensor/src/widgets/navigators/bottom_navigation_bar.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: _contentPageSelected(context),
      ),
      // floatingActionButton: FloatingActionButton(
      //   elevation: 0,
      //   onPressed: () {},
      //   child: const Icon(Icons.camera),
      // ),
      floatingActionButton: ExpandableFab(distance: 112.0, children: [
        ActionButton(
          onPressed: () {},
          icon: const Icon(UniconsLine.microphone),
        ),
        ActionButton(
          onPressed: () {
            captureImage(context);
          },
          icon: const Icon(UniconsLine.image),
        ),
        ActionButton(
          onPressed: () {},
          icon: const Icon(UniconsLine.video),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
      case 2:
      case 3:
        return const MenuPage();
      default:
        return const Dashboard();
    }
  }
}
