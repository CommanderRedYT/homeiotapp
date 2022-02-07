import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homescreen.dart';
import 'globals.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent)))
      .then((value) => SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: [SystemUiOverlay.bottom])
          .then((value) => runApp(const HomeIoT())));

  final prefs = await SharedPreferences.getInstance();

  globals.apiKey = prefs.getString('apiKey');
  globals.apiUser = prefs.getString('apiUser');
  globals.device = prefs.getString('device');
}

class HomeIoT extends StatelessWidget {
  const HomeIoT({Key? key}) : super(key: key);

  static const String _title = 'HomeIoT';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: const HomeScreen(),
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
