import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/preferences/project_preferences.dart';
import 'package:urbansensor/src/services/api_project.dart';
import 'package:urbansensor/src/services/api_report.dart';
import 'package:urbansensor/src/streams/report_stream.dart';
import 'package:urbansensor/src/utils/loading_indicators_c.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/widgets/cards/report_card.dart';
import 'package:urbansensor/src/widgets/input.dart';
import 'package:urbansensor/src/widgets/navigators/back_app_bar.dart';
import 'package:urbansensor/src/widgets/project_setting_item.dart';
import 'package:urbansensor/src/widgets/snack_bar_c.dart';
import 'package:urbansensor/src/widgets/title_page.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  ApiReport apiReport = ApiReport();
  ApiProject apiProject = ApiProject();
  ReportStream stream = ReportStream();
  ScrollController scrollController = ScrollController();
  bool apiSuccess = true;
  final ReceivePort _port = ReceivePort();
  int progress = 0;
  bool deleting = false;
  bool isUpdating = false;
  String _editTitle = '';

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      progress = data[2];

      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
    scrollController.dispose();
    apiReport.clean();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    Project? project = ModalRoute.of(context)?.settings.arguments as Project;
    apiReport.getReportsByProject(projectId: '${project.id}');

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (apiSuccess) {
          if (apiReport.isSearching) {
          } else {
            apiSuccess =
                await apiReport.getReportsByProject(projectId: '${project.id}');
          }
          scrollController.animateTo(scrollController.position.pixels + 30,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn);
        }
      }
    });

    return WillPopScope(
      onWillPop: () async => !deleting,
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            apiSuccess = true;
          });
          apiReport.refreshAllReports('${project.id}');
        },
        color: Colors.white,
        backgroundColor: Palettes.lightBlue,
        child: Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: deleting || isUpdating ? null : const BackAppBar(),
            body: SafeArea(
              child: Center(
                child: isUpdating
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          LoadingIndicatorsC.ballRotateChase,
                          Text('$_editTitle'),
                          const Text('Actualizando'),
                        ],
                      )
                    : Stack(
                        children: [
                          Visibility(
                            visible: !deleting,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TitlePage(
                                          title: '${project.name}',
                                          caption:
                                              '${project.reportsCount} Reportes',
                                        ),
                                      ),
                                      _popUpMenu(project, context),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: _scrollable(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            child: Visibility(
                              visible: deleting,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: LoadingIndicator(
                                        indicatorType: Indicator.ballBeat,
                                      ),
                                    ),
                                    const Text('Eliminando'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            )),
      ),
    );
  }

  Widget _scrollable() {
    return StreamBuilder(
      stream: stream.reportsStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Report>? reports = snapshot.data;
          return Stack(
            children: [
              CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    ListTile(
                      title: Text(
                        'Reportes',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Row(
                        children: [
                          Image.asset(
                            'assets/img/swipe-right.png',
                            width: 25,
                            color: Palettes.lightBlue,
                          ),
                          Text("Desliza para ver las opciones"),
                        ],
                      ),
                    ),
                  ])),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Container(
                        margin: const EdgeInsets.only(
                            bottom: 16.0, left: 16, right: 16),
                        child: ReportCard(report: reports?[index]),
                      ),
                      childCount: reports?.length,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: (MediaQuery.of(context).size.width / 2 - 25),
                child: _loading(),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const Icon(UniconsLine.crosshair);
        } else {
          return LoadingIndicatorsC.ballRotateChase;
        }
      },
    );
  }

  Widget _popUpMenu(Project project, BuildContext context) {
    return PopupMenuButton(
      icon: Material(
        borderRadius: BorderRadius.circular(100),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          child: Icon(
            UniconsLine.ellipsis_v,
            color: Palettes.lightBlue,
            size: 30,
          ),
        ),
      ),
      offset: const Offset(-40, 20),
      tooltip: 'Opciones',
      onSelected: (value) => _optionsAction('$value', project, context),
      color: Palettes.gray5,
      itemBuilder: (BuildContext context) {
        return ProjectSettingItem.options.map((option) {
          return PopupMenuItem(
            value: option,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    option,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                getIconAction(option),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget getIconAction(String option) {
    switch (option) {
      case ProjectSettingItem.Delete:
        return Icon(
          UniconsLine.trash_alt,
          color: Palettes.rose,
        );
      case ProjectSettingItem.Download:
        return Icon(
          UniconsLine.file_download,
          color: Palettes.green2,
        );

      case ProjectSettingItem.OpenInMap:
        return Icon(
          UniconsLine.map,
          color: Palettes.green2,
        );
      case ProjectSettingItem.Modify:
        return Icon(
          UniconsLine.edit,
          color: Palettes.lightBlue,
        );
      default:
        return Icon(UniconsLine.file_download);
    }
  }

  void _optionsAction(
      String action, Project? project, BuildContext context) async {
    switch (action) {
      case ProjectSettingItem.Delete:
        _deleteProject(project, context);
        break;
      case ProjectSettingItem.Download:
        SnackBarC.showSnackbar(message: 'Descargando', context: context);
        await apiProject.downloadReports(projectId: '${project?.id}');
        break;
      case ProjectSettingItem.Modify:
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Editar'),
                Icon(UniconsLine.edit),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Input(
                  label: 'Nombre del proyecto',
                  placeholder: '${project?.name}',
                  func: (value) {
                    _editTitle = value;
                    setState(() {});
                    print(value);
                  },
                ),
              ],
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Cancelar'),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (_editTitle.trim() != '') {
                    setState(() {
                      isUpdating = true;
                    });
                    Navigator.pop(context);
                    FocusScope.of(context).unfocus();
                    project = await apiProject.modifyProject(
                        projectId: '${project?.id}', title: _editTitle);
                    SnackBarC.showSnackbar(
                        message: 'Modificado con exito.', context: context);
                    Navigator.popAndPushNamed(context, 'home',
                        arguments: project);
                  } else {
                    SnackBarC.showSnackbar(
                        message: 'Campo sin completar.', context: context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Modificar',
                    style: TextStyle(color: Palettes.lightBlue),
                  ),
                ),
              )
            ],
          ),
        );

        break;
      case ProjectSettingItem.OpenInMap:
        if (project?.reportsCount == 0) {
          SnackBarC.showSnackbar(
              message: 'No existen reportes.', context: context);
        } else {
          ProjectPreferences preferences = ProjectPreferences();
          preferences.setProject = project;
          Navigator.pushNamed(context, 'projectReports', arguments: project);
        }
        break;
      default:
        break;
    }
  }

  void _deleteProject(Project? project, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Eliminar proyecto'),
            Icon(
              UniconsLine.trash_alt,
              color: Palettes.rose,
            ),
          ],
        ),
        content: Text(
          'El proyecto ${project?.name} sera completamente eliminado, incluyendo los reportes.',
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.w300,
                color: Palettes.gray2,
              ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Palettes.lightBlue),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              setState(() {
                deleting = true;
              });
              final nav = Navigator.of(context);
              nav.pop();
              bool success =
                  await apiProject.deleteProject(projectId: '${project?.id}');
              if (success) {
                nav.pop();
                nav.pushReplacementNamed('home');
              } else {
                setState(() {
                  deleting = false;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Si, estoy seguro',
                style: TextStyle(color: Palettes.rose),
              ),
            ),
          ),
        ],
      ),
    );

    //
  }

  Widget _loading() {
    return StreamBuilder(
        stream: stream.reportLoadedStream,
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
}
