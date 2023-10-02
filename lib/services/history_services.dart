import 'package:http/http.dart' as http;
import 'dart:convert';

String api = 'https://api.duoctaynam.vn';

class HistoryApi {
  static Future<List> loadChuaThanhToan(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/dathang/get_chuathanhtoan'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<List> loadChitietLichSu(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/dathang/listdathanghead'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<List> loadChitietTichLuy(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/dathang/get_chitiet_tichluy'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<List> loadQR(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/dathang/load_qr_thanhtoan'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<List> handleDaThanhToan(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse(api + '/dathang/update_trangthaithanhtoan'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<List> load_sct_thuchi(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/dathang/load_sct_thuchi'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<List> listChitietThuChiHistory(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse(api + '/dathang/list_chitiet_thuchi_history'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<List> KtraUserEGPP(params) async {
    var headers = {
      'Authorization':
          'bearer eyJ0eXAi.iJKV1QiLCJhbGci.iJIUzI1NiJ9OeyJtc2R2IjoiMjIwMjIwMTA1NDA2MzciLCJtc2RuIjoiMDkwNzY3.DIzNCIsInRlbmR2IjoiTkhcdTAwYzAgVEhVXHUxZWQwQyBBTiBUXHUwMGMyTSIsImV4cGlyZWQi.jE3MDk2NTE1MDB9OaIWRy7MMe9EF_QpAar-_qFA.SStlFm4NriftyIcNkzU',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('https://egpp.vn/api_tmdt/tracuu_sdt'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }
}
