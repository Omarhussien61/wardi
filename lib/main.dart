import 'package:flutter/material.dart';
import 'package:wardi/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        fontFamily: 'Tajawal',
        primaryColor: const Color.fromRGBO(220, 108, 163, 1)
      ),
      supportedLocales: const [
        Locale('ar','SA'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      locale: const Locale('ar'),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
