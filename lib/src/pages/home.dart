import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urbansensor/src/content/dashboard.dart';
import 'package:urbansensor/src/pages/menu_page.dart';
import 'package:urbansensor/src/pages/projects_page.dart';
import 'package:urbansensor/src/providers/navigation_provider.dart';
import 'package:urbansensor/src/widgets/expandable_fab_test.dart';
import 'package:urbansensor/src/widgets/navigators/bottom_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _lastSelected = 'TAB: 0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(child: _contentPageSelected(context)),
      // floatingActionButton: FloatingActionButton(
      //   elevation: 0,
      //   onPressed: () {},
      //   child: const Icon(Icons.camera),
      // ),
      // floatingActionButton: ExpandableFab(distance: 112.0, children: [
      //   ActionButton(
      //     onPressed: () {},
      //     icon: const Icon(UniconsLine.microphone),
      //   ),
      //   ActionButton(
      //     onPressed: () {},
      //     icon: const Icon(UniconsLine.image),
      //   ),
      //   ActionButton(
      //     onPressed: () {},
      //     icon: const Icon(UniconsLine.video),
      //   ),
      // ]),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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

  Widget _buildFab(BuildContext context) {
    final icons = [Icons.sms, Icons.mail, Icons.phone];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: ExpandableFabTest(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: FloatingActionButton.small(
        onPressed: () {},
        tooltip: "Increment",
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
    // return ExpandableFabTest(icons: icons, onIconTapped: (index) {});
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }
}
