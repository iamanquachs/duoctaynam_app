import 'package:http/http.dart' as http;
import 'dart:convert';

String api = 'https://api.duoctaynam.vn';

class OrderApi {
  static Future<List> loadListOrder(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(api + '/yeucau/load_yeucau'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<void> deleteOrder(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/yeucau/delete_yeucau'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    await request.send();
  }

  static Future<void> addOrder(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(api + '/yeucau/add_yeucau'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    await request.send();
  }
}
