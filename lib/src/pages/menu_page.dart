import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/preferences/user_preferences.dart';

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
            onTap: () {
              UserPreferences().logout();
              Navigator.pushReplacementNamed(context, "login");
            },
          ),
        ],
      ),
    );
  }
}
