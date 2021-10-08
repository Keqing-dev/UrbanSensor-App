import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/preferences/user_preferences.dart';
import 'package:urbansensor/src/providers/navigation_provider.dart';
import 'package:urbansensor/src/services/api.dart';
import 'package:urbansensor/src/widgets/input.dart';
import 'package:urbansensor/src/widgets/snack_bar_c.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _observationsController = TextEditingController();

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
              UniconsLine.feedback,
              color: theme.colorScheme.secondary,
            ),
            title: const Text('Feedback'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                    title: const Text('Feedbackasd  sasasds'),
                    actions: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar'),
                      ),
                      InkWell(
                        onTap: () async {
                          String value = _observationsController.text;

                          if (value.trim() == '') {
                            SnackBarC.showSnackbar(
                                message: 'Debes escribir algo.',
                                context: context);
                          } else {
                            Api api = Api();
                            await api.createFeedback(value);
                            Navigator.pop(context);
                            SnackBarC.showSnackbar(
                                message: 'Enviado', context: context);
                          }
                        },
                        child: Text('Enviar'),
                      ),
                    ],
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Input(
                          controller: _observationsController,
                          label: "Comentarios",
                          placeholder: "Escribe tu comentario",
                          height: 112.0,
                          maxLines: 5,
                          minLines: 5,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
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
