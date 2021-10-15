import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:historyar_app/pages/sign_in_pages/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Historyar',
      theme: ThemeData(

      ),
      home: Splash(),
    );
  }
}

