import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:upwork_videocall/helpers/shared-prefs.dart';
import 'package:upwork_videocall/utilities/GlobalVariables.dart';

class WebService {
  Future<dynamic> sendRequestWithPost(String url, dynamic body) async {
    var result = await http.post(Uri.parse(GlobalVariables.baseUrl(url)),
        body: json.encode(body));
    var jsonResponse = json.decode(result.body);
    return jsonResponse;
  }

  Future<dynamic> sendRequestWithPostAndToken(String url, dynamic body) async {
    var result = await http.post(
      Uri.parse(GlobalVariables.baseUrl(url)),
      headers: {'Authorization': 'Bearer ' + SharedPrefs.getToken},
      body: json.encode(body),
    );
    var jsonResponse = json.decode(result.body);
    return jsonResponse;
  }

  Future<dynamic> sendRequestWithGet(String url) async {
    var result = await http.get(Uri.parse(GlobalVariables.baseUrl(url)),
        headers: {'Authorization': 'Bearer ' + SharedPrefs.getToken});
    var jsonResponse = json.decode(result.body);
    return jsonResponse;
  }
}
