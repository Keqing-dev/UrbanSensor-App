import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:urbansensor/src/pages/home.dart';
import 'package:urbansensor/src/pages/project_page.dart';
import 'package:urbansensor/src/providers/navigation_provider.dart';
import 'package:urbansensor/src/utils/palettes.dart';
import 'package:urbansensor/src/pages/login.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color.fromRGBO(204, 204, 204, 1),
        systemNavigationBarIconBrightness: Brightness.dark),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          canvasColor: Palettes.gray5,
          textTheme: GoogleFonts.montserratTextTheme(),
        ),
        initialRoute: 'login',
        routes: {
          'home': (BuildContext context) => const Home(),
          'project': (BuildContext context) => const ProjectPage(),
          'login': (BuildContext context) => Login(),
        },
      ),
    );
  }
}
