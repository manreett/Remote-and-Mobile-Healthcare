import 'dart:convert';
import 'package:http/http.dart' as http;

class JSONParser {
  Future<Map<String, dynamic>> makeHttpRequest(String url, String method,
      {required List<Map<String, String>> params}) async {
    var response, json;
    if (method == 'POST') {
      response = await http.post(Uri.parse(url), body: params.first);
    } else if (method == 'GET') {
      String paramString = Uri(queryParameters: params.first).query;
      response = await http.get(Uri.parse('$url?$paramString'));
    }
    json = jsonDecode(utf8.decode(response.bodyBytes));
    return {'data': json, 'statusCode': response.statusCode};
  }
}
