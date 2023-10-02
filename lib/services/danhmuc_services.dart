import 'package:app_dtn/model/danhmuc_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String api = 'https://api.duoctaynam.vn';

class ListNhomApi {
  static Future<List<ListNhom>> listNhom(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(api + '/danhmuc/listdanhmuc'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;
    final lists = res.map((e) {
      return ListNhom(
        tenloai: e['tenloai'],
        msloai: e['msloai'],
        dieukien2: e['dieukien2'],
      );
    }).toList();
    return lists;
  }
}
