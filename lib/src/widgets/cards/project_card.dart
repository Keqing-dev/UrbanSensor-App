import 'package:flutter/material.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/utils/shadow.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({Key? key, required this.project}) : super(key: key);
  final Project? project;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: shadow(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.folder_open,
                  size: 40,
                  color: Palettes.green2,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${project?.name}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Palettes.gray2,
                          ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.analytics_outlined,
                            color: Palettes.gray3,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${project?.reportsCount} reportes',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Palettes.gray2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.pushNamed(context, 'project', arguments: project);
              },
            ),
          ),
        ),
      ],
    );
  }
}
