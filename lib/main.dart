import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:urbansensor/src/pages/home.dart';
import 'package:urbansensor/src/pages/project_page.dart';
import 'package:urbansensor/src/preferences/user_preferences.dart';
import 'package:urbansensor/src/providers/navigation_provider.dart';
import 'package:urbansensor/src/providers/user_provider.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/pages/login.dart';

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
  final userPreferences = UserPreferences();
  await userPreferences.initPreferences();
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
      ],
      child: MaterialApp(
        title: 'UrbanSensor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          canvasColor: Palettes.gray5,
          textTheme: GoogleFonts.montserratTextTheme(),
        ),
        initialRoute: isLogged ? 'home' : 'login',
        routes: {
          'login': (BuildContext context) => const Login(),
          'home': (BuildContext context) => const Home(),
          'project': (BuildContext context) => const ProjectPage(),
        },
      ),
    );
  }
}
