library homeiotapp.thingerio;

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'globals.dart' as globals;

class ThingerIO {
  Future<dynamic> getFromAPI(String device, String resource) async {
    if (globals.apiUser == null) {
      return;
    }

    var url = Uri.parse(
        'https://backend.thinger.io/v3/users/${globals.apiUser!}/devices/$device/$resource');
    var response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${globals.apiKey}'});
    if (response.statusCode != 200) {
      return;
    }
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  }

  Future<dynamic> getDeviceStatus(String device) async {
    if (globals.apiUser == null) {
      return;
    }
    var url = Uri.parse(
        'https://backend.thinger.io/v1/users/${globals.apiUser!}/devices/$device/stats');
    var response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${globals.apiKey}'});
    if (response.statusCode != 200) {
      log(response.body);
      return;
    }
    log(response.body);
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  }
}
