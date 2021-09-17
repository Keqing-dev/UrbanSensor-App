import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/providers/navigation_provider.dart';

class BottomNavigationBarC extends StatelessWidget {
  const BottomNavigationBarC({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.black12),
      child: BottomAppBar(
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          unselectedItemColor: const Color.fromRGBO(107, 107, 107, 1),
          elevation: 0,
          currentIndex: navigationProvider.selectedIndex,
          onTap: (value) => navigationProvider.selectedIndex = value,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(UniconsLine.estate), label: 'Inicio'),
            BottomNavigationBarItem(
                icon: Icon(Icons.folder_open), label: 'Proyectos'),
            BottomNavigationBarItem(
                icon: Icon(Icons.analytics_outlined), label: 'Reportes'),
          ],
        ),
      ),
    );
  }
}
