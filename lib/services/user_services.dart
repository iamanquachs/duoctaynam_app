import 'package:http/http.dart' as http;
import 'package:app_dtn/model/user_model.dart';
import 'dart:convert';

String api = 'https://api.duoctaynam.vn';

class Login {
  static Future<List<User>> login(params) async {
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

    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;
    final lists = res.map((e) {
      return User(
        msdv: e['msdv'],
        tendv: e['tendv'],
        tendaidien: e['tendaidien'],
        diachi: e['diachi'],
        msxa: e['msxa'],
      );
    }).toList();
    return lists;
  }

  static Future<List<UserDtn>> KtraDTN(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('https://api.duoctaynam.vn/danhmuc/checkMSDN'));
    request.body = json.encode({"msdn": params});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;
    final lists = res.map((e) {
      return UserDtn(
        msdv: e['msdv'],
        tenkhachhang: e['tenkhachhang'],
        diachi: e['diachi'],
        msxa: e['msxa'],
      );
    }).toList();
    return lists;
  }

  static Future<List> loadBanner(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('https://api.duoctaynam.vn/banner/load_banner'));
    request.body = json.encode({"msdn": params});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;

    return res;
  }

}
