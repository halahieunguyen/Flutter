import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
extension IsOk on http.Response {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}
  String host = "https://66f5-118-71-167-168.ap.ngrok.io/";
  String hostApi = host + "api/";
  String hostImg = host + "tmp_images/";
  Future<http.Response> post(String url, Map<String, dynamic> data) async{
    final prefs = await SharedPreferences.getInstance();
    final access_token = prefs.getString('access_token') ?? null;
    // token = localStorage.getItem("token");
    Map<String, String> header = {};
    if (access_token != null) header = { 'Authorization': "Bearer $access_token"};
    var res = await http.post(
      Uri.parse(hostApi + url),
      headers: header,
      body: data
    );
    return res;
  }

  Future<http.Response> get(String url, Map<String, dynamic> queryParam) async {
    final prefs = await SharedPreferences.getInstance();
    final access_token = prefs.getString('access_token') ?? null;
    Map<String, String> header = {};
    if (access_token != null) header = { 'Authorization': "Bearer $access_token"};
    var res = await http.get(
      Uri.parse(hostApi + url).replace(queryParameters: queryParam),
      headers: header,
    );
    return res;
  }