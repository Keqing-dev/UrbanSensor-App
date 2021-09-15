import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/models/user.dart';
import 'package:urbansensor/src/preferences/user_preferences.dart';
import 'package:urbansensor/src/services/api.dart';
import 'package:urbansensor/src/services/api_project.dart';
import 'package:urbansensor/src/services/api_report.dart';
import 'package:urbansensor/src/utils/loading_indicators_c.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/utils/text_style_c.dart';
import 'package:urbansensor/src/widgets/cards/project_card.dart';
import 'package:urbansensor/src/widgets/cards/report_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    Api api = Api();
    ApiProject apiProject = ApiProject();
    ApiReport apiReport = ApiReport();

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _profileInfo(context),
          _label(
            context: context,
            title: 'Proyectos',
            iconData: Icons.scatter_plot_outlined,
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: _latestProject(apiProject)),
          _label(
            context: context,
            title: 'Reportes',
            iconData: Icons.analytics_outlined,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: _latestReports(apiReport),
          ),
        ],
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    User? user = UserPreferences().getUser;

    print(user?.name);
    final _caption = Theme.of(context)
        .textTheme
        .caption!
        .copyWith(fontWeight: FontWeight.w300, color: Palettes.gray3);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: user?.thumbnails?.lg != null
                    ? '${user?.thumbnails?.lg}'
                    : 'https://thispersondoesnotexist.com/image',
                errorWidget: (context, url, error) => const Text('Error'),
                placeholder: (context, url) => LoadingIndicatorsC.ballScale,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${user?.name} ${user?.lastName}',
                        style: TextStyleC.bodyText1(
                            context: context, fontWeight: 'semi')),
                    Text('Plan ${user?.plan?.name}', style: _caption),
                    Text('13 Proyectos', style: _caption),
                    Text('15 Reportes', style: _caption),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(
      {required BuildContext context,
      required String title,
      required IconData iconData}) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: Icon(
            iconData,
            color: Palettes.gray3,
            size: 30,
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.w500, color: Palettes.gray3, fontSize: 18),
        ),
      ],
    );
  }

  Widget _latestProject(ApiProject api) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
            future: api.getLatestProject(),
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
                      children: const [
                        Text(
                          'No cuentas con proyectos aun, crea uno y empieza a compartir tus reportes',
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.nearby_error, size: 40),
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
            onTap: () {},
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

  Widget _latestReports(ApiReport api) {
    return FutureBuilder(
        future: api.getLatestReport(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Report>? reports = snapshot.data;
            return _reportList(reports);
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
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: ReportCard(report: reports?[index]),
        );
      },
    );
  }
}
