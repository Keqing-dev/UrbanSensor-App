import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/utils/shadow.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({Key? key, required this.project, this.onTap})
      : super(key: key);
  final Project? project;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: shadow(),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (onTap != null) {
              onTap!();
            } else {
              Navigator.pushNamed(context, 'project', arguments: project);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    UniconsLine.folder,
                    size: 35,
                    color: Palettes.lightBlue,
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
                              fontWeight: FontWeight.w500,
                              color: Palettes.gray2,
                            ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Icon(
                              UniconsLine.chart,
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
        ),
      ),
    );
  }
}

