import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:urbansensor/src/pages/create_project.dart';
import 'package:urbansensor/src/pages/home.dart';
import 'package:urbansensor/src/pages/login_page.dart';
import 'package:urbansensor/src/pages/project_page.dart';
import 'package:urbansensor/src/pages/project_reports.dart';
import 'package:urbansensor/src/pages/record_audio_page.dart';
import 'package:urbansensor/src/pages/register_page.dart';
import 'package:urbansensor/src/pages/report_page.dart';
import 'package:urbansensor/src/pages/test_components.dart';
import 'package:urbansensor/src/preferences/project_preferences.dart';
import 'package:urbansensor/src/preferences/user_preferences.dart';
import 'package:urbansensor/src/providers/navigation_provider.dart';
import 'package:urbansensor/src/providers/project_provider.dart';
import 'package:urbansensor/src/providers/user_provider.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/utils/theme.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color.fromRGBO(204, 204, 204, 1),
        systemNavigationBarIconBrightness: Brightness.dark),
  );

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: false // optional: set false to disable printing logs to console
      );
  final userPreferences = UserPreferences();
  await userPreferences.initPreferences();

  final projectPreferences = ProjectPreferences();
  await projectPreferences.initPreferences();

  await Jiffy.locale("es");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLogged = UserPreferences().isLogged;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ProjectProvider()),
      ],
      child: MaterialApp(
        title: 'UrbanSensor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          canvasColor: Palettes.gray5,
          fontFamily: 'Montserrat',
          appBarTheme: const AppBarTheme(
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          textTheme: CustomTheme.textTheme,
        ),
        initialRoute: isLogged ? 'home' : 'login',
        routes: {
          'login': (BuildContext context) => const LoginPage(),
          'register': (BuildContext context) => const RegisterPage(),
          'home': (BuildContext context) => const Home(),
          'project': (BuildContext context) => const ProjectPage(),
          'createProject': (BuildContext context) => const CreateProject(),
          'report': (BuildContext context) => const ReportPage(),
          'projectReports': (BuildContext context) => const ProjectReports(),
          'record_audio_page': (BuildContext context) =>
              const RecordAudioPage(),
          'test': (BuildContext context) => const TestComponents(),
          // 'createReport': (BuildContext context) => const CreateReportPage(fileType: FileType.photo,),
        },
      ),
    );
  }
}
