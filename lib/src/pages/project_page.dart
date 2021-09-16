import 'package:flutter/material.dart';
import 'package:urbansensor/src/models/project.dart';
import 'package:urbansensor/src/models/report.dart';
import 'package:urbansensor/src/services/api_report.dart';
import 'package:urbansensor/src/streams/report_stream.dart';
import 'package:urbansensor/src/utils/loading_indicators_c.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/widgets/cards/report_card.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  ApiReport apiReport = ApiReport();
  ReportStream reportStream = ReportStream();
  ScrollController scrollController = ScrollController();
  bool apiSuccess = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        color: Palettes.gray2,
                      ),
                      Text('${project.reportsCount} Reportes'),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 30),
                    child: Row(
                      children: [
                        _label(
                            context: context,
                            iconData: Icons.analytics_outlined,
                            title: 'Reportes'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      child: _scrollable(),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _scrollable() {
    return StreamBuilder(
        stream: reportStream.reportsStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Report>? reports = snapshot.data;
            return CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => Container(
                              margin: const EdgeInsets.only(
                                  bottom: 16.0, left: 16, right: 16),
                              child: ReportCard(report: reports?[index]),
                            ),
                        childCount: reports?.length)),
              ],
            );
          } else if (snapshot.hasError) {
            return Icon(Icons.error_outline);
          } else {
            return LoadingIndicatorsC.ballRotateChase;
          }
        });
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
}
