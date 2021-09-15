import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urbansensor/src/pages/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme()
      ),
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => Login(),
      },
    );
  }
}
