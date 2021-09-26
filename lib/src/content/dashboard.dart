import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/services/api_project.dart';
import 'package:urbansensor/src/services/api_report.dart';
import 'package:urbansensor/src/streams/report_stream.dart';
import 'package:urbansensor/src/utils/loading_indicators_c.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/widgets/cards/project_card.dart';
import 'package:urbansensor/src/widgets/cards/report_card.dart';
import 'package:urbansensor/src/widgets/label.dart';
import 'package:urbansensor/src/widgets/profile_info.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ApiProject apiProject = ApiProject();
  ApiReport apiReport = ApiReport();
  ReportStream reportStream = ReportStream();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiReport.getLatestReport();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await apiReport.getLatestReport();
        setState(() {});
      },
      color: Colors.white,
      backgroundColor: Palettes.lightBlue,
      child: ListView(
        children: [
          const ProfileInfo(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Label(
              title: 'Proyectos',
              iconData: UniconsLine.channel,
              iconColor: Palettes.lightBlue,
              info: 'Desliza para refrescar.',
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: _latestProject(apiProject, context)),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: _latestReports(),
          ),
        ],
      ),
    );
  }

  Widget _latestProject(ApiProject api, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
            future: api.getLatestProject(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Project>? projects = snapshot.data;
                return _projectList(projects);
              } else if (snapshot.hasError) {
                return Expanded(
                  child: Container(
                    height: 220,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No cuentas con proyectos aun, crea uno y empieza a compartir tus reportes',
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            UniconsLine.robot,
                            size: 40,
                            color: Palettes.green2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return LoadingIndicatorsC.ballRotateChaseExpanded;
              }
            }),
        Material(
          borderRadius: BorderRadius.circular(8),
          color: Palettes.lightBlue,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'createProject');
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              height: 222,
              width: 107,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Crear Proyecto',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _projectList(List<Project>? projects) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: projects?.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 10),
            child: ProjectCard(project: projects?[index]),
          );
        },
      ),
    );
  }

  Widget _latestReports() {
    ReportStream stream = ReportStream();

    return StreamBuilder(
        stream: stream.reportsLatestStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Report>? reports = snapshot.data;
            return Column(
              children: [
                reports!.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Label(
                          title: 'Reportes',
                          iconData: UniconsLine.chart,
                          iconColor: Palettes.lightBlue,
                          info: 'Últimos 10 reportes',
                        ),
                      )
                    : Container(),
                _reportList(reports),
              ],
            );
          } else if (snapshot.hasError) {
            return Row(
              children: const [
                Text('No cuentas con reportes.'),
              ],
            );
          } else {
            return LoadingIndicatorsC.ballRotateChase;
          }
        });
  }

  Widget _reportList(List<Report>? reports) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: reports?.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ReportCard(report: reports?[index]),
        );
      },
    );
  }
}
