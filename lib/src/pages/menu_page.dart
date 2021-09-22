import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/preferences/user_preferences.dart';
import 'package:urbansensor/src/providers/navigation_provider.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: Icon(
              UniconsLine.info_circle,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Terminos y Condiciones'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              UniconsLine.question_circle,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Ayuda'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              UniconsLine.signout,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Cerrar Sesión'),
            onTap: () async {
              NavigationProvider navProvider =
                  Provider.of<NavigationProvider>(context, listen: false);
              UserPreferences().logout();
              await Navigator.pushReplacementNamed(context, "login");
              navProvider.selectedIndex = 0;
            },
          ),
        ],
      ),
    );
  }
}
