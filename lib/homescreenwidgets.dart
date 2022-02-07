import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'qrscan.dart';
import 'globals.dart' as globals;

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("StatusPage")),
    );
  }
}

class ControlsPage extends StatelessWidget {
  const ControlsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("ControlsPage")),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _updateKeyCallback(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('apiKey', apiKey);
    setState(() {
      globals.apiKey = apiKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(globals.apiKey ?? 'No API Key set'),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ScanQrCodeScreen(update: _updateKeyCallback)));
                },
                child: const Text("Open QR Scan"))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}
