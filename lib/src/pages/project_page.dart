import 'package:flutter/material.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/utils/palettes.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Project? project = ModalRoute.of(context)?.settings.arguments as Project;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_left,
            size: 50,
            color: Palettes.rose,
          ),
        ),
        title: Text('Volver',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Palettes.gray2,
                )),
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  Text(
                    '${project.name}',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Palettes.gray2,
                        ),
                  ),
                  Text('${project.reportsCount} Reportes'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
