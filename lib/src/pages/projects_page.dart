import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/services/api_project.dart';
import 'package:urbansensor/src/streams/project_stream.dart';
import 'package:urbansensor/src/utils/debouncer.dart';
import 'package:urbansensor/src/utils/loading_indicators_c.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/widgets/cards/project_card.dart';
import 'package:urbansensor/src/widgets/input_search.dart';
import 'package:urbansensor/src/widgets/title_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  ProjectStream stream = ProjectStream();
  ApiProject apiProject = ApiProject();
  bool apiSuccess = true;
  ScrollController scrollController = ScrollController();
  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));
  String searchValue = '';
  int maxItems = 0;

  @override
  void initState() {
    super.initState();
    apiProject.getAllMyProjects();

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (apiSuccess) {
          if (apiProject.isSearching) {
            apiSuccess = await apiProject.searchMyProjects(name: searchValue);
          } else {
            apiSuccess = await apiProject.getAllMyProjects();
          }
          scrollController.animateTo(scrollController.position.pixels + 30,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        apiSuccess = true;
        apiProject.refreshAllMyProjects();
      },
      color: Colors.white,
      backgroundColor: Palettes.lightBlue,
      edgeOffset: 20,
      child: Column(
        children: [
          StreamBuilder(
              stream: stream.maxItemsStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                int? counts = snapshot.data ?? 0;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: TitlePage(
                    title: 'Mis Proyectos',
                    caption: '$counts Proyectos encontrados.',
                    iconData: UniconsLine.folder_plus,
                    iconFunc: () =>
                        Navigator.pushNamed(context, 'createProject'),
                  ),
                );
              }),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
            child: InputSearch(func: (value) {
              _searchMyProjects(value);
            }),
          ),
          Expanded(
            child: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder(
                  stream: stream.projectsStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          Positioned.fill(child: _scrollView(snapshot.data)),
                          Positioned(
                            bottom: 0,
                            left: (MediaQuery.of(context).size.width / 2) - 30,
                            child: _loading(),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return const Icon(Icons.error_outline);
                    } else {
                      return LoadingIndicatorsC.ballRotateChase;
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scrollView(List<Project>? projects) {
    return projects!.isNotEmpty
        ? CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                      margin: const EdgeInsets.only(
                          bottom: 16.0, left: 16, right: 16),
                      child: ProjectCard(project: projects[index]));
                }, childCount: projects.length),
              ),
            ],
          )
        : Center(
            child: Text(
            apiProject.isSearching
                ? apiProject.isSearchEmpty
                    ? 'No hemos podido encontrar '
                    : 'Buscando...'
                : !apiSuccess
                    ? 'No cuentas con proyectos aun, crea uno y empieza a compartir tus reportes'
                    : '',
            textAlign: TextAlign.center,
          ));
  }

  Widget _loading() {
    return StreamBuilder(
        stream: stream.projectLoadedStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return !snapshot.data
                ? LoadingIndicatorsC.ballRotateChaseSmall
                : Container();
          } else {
            return Container();
          }
        });
  }

  void _searchMyProjects(String text) {
    apiProject.searchPage = 1;
    apiProject.cleanProjects();
    debouncer.value = '';
    debouncer.onValue = (value) async {
      if (value.toString().isEmpty) {
        apiProject.cleanSearch();
        apiProject.getAllMyProjects();
      } else {
        setState(() {
          searchValue = value;
        });
        apiProject.searchMyProjects(name: value);
      }
      FocusScope.of(context).unfocus();
    };

    final timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      debouncer.value = text;
    });

    Future.delayed(const Duration(milliseconds: 251))
        .then((_) => timer.cancel());
  }
}
