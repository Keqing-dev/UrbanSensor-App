import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import 'package:urbansensor/src/content/dashboard.dart';
import 'package:urbansensor/src/pages/create_report_page.dart';
import 'package:urbansensor/src/pages/menu_page.dart';
import 'package:urbansensor/src/pages/projects_page.dart';
import 'package:urbansensor/src/providers/navigation_provider.dart';
import 'package:urbansensor/src/widgets/expandable_fab.dart';
import 'package:urbansensor/src/widgets/file_type.dart';
import 'package:urbansensor/src/widgets/navigators/bottom_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _retrieveLostData(context);
  }

  Future<void> _retrieveLostData(BuildContext context) async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      response.type == RetrieveType.image
          ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateReportPage(
                  fileType: FileType.photo,
                  lostFile: response.file,
                ),
              ),
            )
          : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateReportPage(
                  fileType: FileType.video,
                  lostFile: response.file,
                ),
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        // bottom: false,
        child: _contentPageSelected(context),
      ),
      // floatingActionButton: FloatingActionButton(
      //   elevation: 0,
      //   onPressed: () {},
      //   child: const Icon(Icons.camera),
      // ),
      floatingActionButton: ExpandableFab(distance: 112.0, children: [
        ActionButton(
          onPressed: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateReportPage(
                  fileType: FileType.mic,
                ),
              ),
            );*/

            Navigator.pushNamed(context, 'record_audio_page');
          },
          icon: const Icon(UniconsLine.microphone),
        ),
        ActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateReportPage(
                  fileType: FileType.photo,
                ),
              ),
            );
          },
          icon: const Icon(UniconsLine.image),
        ),
        ActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateReportPage(
                  fileType: FileType.video,
                ),
              ),
            );
          },
          icon: const Icon(UniconsLine.video),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const BottomNavigationBarC(),
    );
  }

  Widget _contentPageSelected(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    switch (navigationProvider.selectedIndex) {
      case 0:
        return const Dashboard();
      case 1:
        return const ProjectsPage();
      case 2:
        return const MenuPage();
      default:
        return const Dashboard();
    }
  }
}
