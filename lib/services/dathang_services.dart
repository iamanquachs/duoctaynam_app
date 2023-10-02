import 'package:app_dtn/model/dathang_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String api = 'https://api.duoctaynam.vn';
String api_local = 'http://localhost/2023/TPSPharma/TPS_nextjs/Backend';

class DatHang {
  static Future<List<KtraCart>> handleKtraCart(params) async {
    var headers = {
      'Authorization':
          'bearer eyJ0eXAi.iJKV1QiLCJhbGci.iJIUzI1NiJ9OeyJtc2R2IjoiMjIwMjIwMTA1NDA2MzciLCJtc2RuIjoiMDkwNzY3.DIzNCIsInRlbmR2IjoiTkhcdTAwYzAgVEhVXHUxZWQwQyBBTiBUXHUwMGMyTSIsImV4cGlyZWQi.jE3MDk2NTE1MDB9OaIWRy7MMe9EF_QpAar-_qFA.SStlFm4NriftyIcNkzU',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse(api + '/dathang/list_kt_mshh_dathangline'));
    request.body = json.encode(params);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;
    final lists = res.map((e) {
      return KtraCart(
        soluong: e['soluong'],
      );
    }).toList();
    return lists;
  }

  static Future<void> handleDathangLine(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/dathang/dathangline_add'));
    request.body = json.encode(params);
    request.headers.addAll(headers);
    await request.send();
  }

  static Future<void> handleUpdateDathangLine(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/dathang/update_dathangline'));
    request.body = json.encode(params);
    request.headers.addAll(headers);
    await request.send();
  }
}
