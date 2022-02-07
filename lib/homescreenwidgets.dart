import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'qrscan.dart';
import 'globals.dart' as globals;
import 'thinger_io.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  Timer? timer;
  ThingerIO thinger = ThingerIO();

  static String _deviceStatus = 'Loading...';

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      thinger.getDeviceStatus(globals.device!).then((value) {
        var json = value as Map;
        if (json['connected']) {
          var date = DateTime.fromMillisecondsSinceEpoch(json['connected_ts']);
          setState(() {
            _deviceStatus = 'Online since: ${timeago.format(date)}';
          });
        } else {
          setState(() {
            _deviceStatus = "Device offline";
          });
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Text that is set to the response of the getDeviceStatus call
            Text(
              _deviceStatus,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ),
    );
  }
}

class ControlsPage extends StatefulWidget {
  const ControlsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
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

  TextEditingController? usernameController;
  TextEditingController? deviceController;

  @override
  initState() {
    super.initState();
    usernameController = TextEditingController(text: globals.apiUser);
    deviceController = TextEditingController(text: globals.device);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text(globals.apiKey ?? 'No API Key set'),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ScanQrCodeScreen(update: _updateKeyCallback)));
                },
                child: const Text("Open QR Scan")),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter username',
              ),
              controller: usernameController,
              onChanged: (value) async {
                setState(() {
                  globals.apiUser = value;
                });
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('apiUser', value);
              },
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter device',
              ),
              controller: deviceController,
              onChanged: (value) async {
                setState(() {
                  globals.device = value;
                });
                final prefs = await SharedPreferences.getInstance();
                prefs.setString('device', value);
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}
