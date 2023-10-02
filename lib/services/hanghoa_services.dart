import 'package:app_dtn/model/hanghoa_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String api = 'https://api.duoctaynam.vn';

class HangHoa {
  static Future<List<SanPham>> listNoiBat(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/hanghoa/list_hanghoa_noibat'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;
    final lists = res.map((e) {
      return SanPham(
        mshh: e['mshh'],
        tenhh: e['tenhh'],
        path_image: e['path_image'],
        path_image_child: e['path_image_child'],
        hamluong: e['hamluong'],
        tenhoatchat: e['tenhoatchat'],
        tennhom: e['tennhom'],
        quycach: e['quycach'],
        standard: e['standard'],
        tennhasx: e['tennhasx'],
        country: e['country'],
        tim: e['tim'],
        chitu: e['chitu'],
        mshhnpp: e['mshhnpp'],
        mshhncc: e['mshhncc'],
        dvt: e['dvtmin'],
        msnpp: e['msnpp'],
        pttichluy: e['pttichluy'],
        thuesuat: e['thuesuat'],
        ptgiam: e['ptgiam'],
        loaikm: e['loaikm'],
        msctkm: e['msctkm'],
        url: e['url'],
        tenctkm: e['tenctkm'],
        dieukien2: e['dieukien2'],
        theodon: e['theodon'],
        sodangky: e['sodangky'],
        groupproduct: e['groupproduct'],
        mshh_mua: e['mshh_mua'],
      );
    }).toList();
    return lists;
  }

  static Future<List<SanPham>> listAllHanghoa(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(api + '/hanghoa/list'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;
    final lists = res.map((e) {
      return SanPham(
        mshh: e['mshh'],
        tenhh: e['tenhh'],
        path_image: e['path_image'],
        path_image_child: e['path_image_child'],
        hamluong: e['hamluong'],
        tenhoatchat: e['tenhoatchat'],
        tennhom: e['tennhom'],
        quycach: e['quycach'],
        standard: e['standard'],
        tennhasx: e['tennhasx'],
        country: e['country'],
        tim: e['tim'],
        chitu: e['chitu'],
        mshhnpp: e['mshhnpp'],
        mshhncc: e['mshhncc'],
        dvt: e['dvtmin'],
        msnpp: e['msnpp'],
        pttichluy: e['pttichluy'],
        thuesuat: e['thuesuat'],
        ptgiam: e['ptgiam'],
        loaikm: e['loaikm'],
        msctkm: e['msctkm'],
        url: e['url'],
        tenctkm: e['tenctkm'],
        dieukien2: e['dieukien2'],
        theodon: e['theodon'],
        sodangky: e['sodangky'],
        mshh_mua: e['mshh_mua'],
        groupproduct: e['groupproduct'],
      );
    }).toList();
    return lists;
  }

  static Future<List<SanPham>> listHotItems(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/hanghoa/list_hot_items'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;
    final lists = res.map((e) {
      return SanPham(
        mshh: e['mshh'],
        tenhh: e['tenhh'],
        path_image: e['path_image'],
        path_image_child: e['path_image_child'],
        hamluong: e['hamluong'],
        tenhoatchat: e['tenhoatchat'],
        tennhom: e['tennhom'],
        quycach: e['quycach'],
        standard: e['standard'],
        tennhasx: e['tennhasx'],
        country: e['country'],
        tim: e['tim'],
        chitu: e['chitu'],
        mshhnpp: e['mshhnpp'],
        mshhncc: e['mshhncc'],
        dvt: e['dvtmin'],
        msnpp: e['msnpp'],
        pttichluy: e['pttichluy'],
        thuesuat: e['thuesuat'],
        ptgiam: e['ptgiam'],
        loaikm: e['loaikm'],
        msctkm: e['msctkm'],
        url: e['url'],
        tenctkm: e['tenctkm'],
        dieukien2: e['dieukien2'],
        theodon: e['theodon'],
        sodangky: e['sodangky'],
        mshh_mua: e['mshh_mua'],
        groupproduct: e['groupproduct'],
      );
    }).toList();
    return lists;
  }

  static Future<List<SanPham>> listSearch(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(api + '/hanghoa/list_search'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;
    final lists = res.map((e) {
      return SanPham(
        mshh: e['mshh'],
        tenhh: e['tenhh'],
        path_image: e['path_image'],
        path_image_child: e['path_image_child'],
        hamluong: e['hamluong'],
        tenhoatchat: e['tenhoatchat'],
        tennhom: e['tennhom'],
        quycach: e['quycach'],
        standard: e['standard'],
        tennhasx: e['tennhasx'],
        country: e['country'],
        tim: e['tim'],
        chitu: e['chitu'],
        mshhnpp: e['mshhnpp'],
        mshhncc: e['mshhncc'],
        dvt: e['dvtmin'],
        msnpp: e['msnpp'],
        pttichluy: e['pttichluy'],
        thuesuat: e['thuesuat'],
        ptgiam: e['ptgiam'],
        loaikm: e['loaikm'],
        msctkm: e['msctkm'],
        url: e['url'],
        tenctkm: e['tenctkm'],
        dieukien2: e['dieukien2'],
        theodon: e['theodon'],
        sodangky: e['sodangky'],
        mshh_mua: e['mshh_mua'],
        groupproduct: e['groupproduct'],
      );
    }).toList();
    return lists;
  }

  static Future<List<SanPham>> listFilter(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(api + '/hanghoa/list_filter'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;
    final lists = res.map((e) {
      return SanPham(
        mshh: e['mshh'],
        tenhh: e['tenhh'],
        path_image: e['path_image'],
        path_image_child: e['path_image_child'],
        hamluong: e['hamluong'],
        tenhoatchat: e['tenhoatchat'],
        tennhom: e['tennhom'],
        quycach: e['quycach'],
        standard: e['standard'],
        tennhasx: e['tennhasx'],
        country: e['country'],
        tim: e['tim'],
        chitu: e['chitu'],
        mshhnpp: e['mshhnpp'],
        mshhncc: e['mshhncc'],
        dvt: e['dvtmin'],
        msnpp: e['msnpp'],
        pttichluy: e['pttichluy'],
        thuesuat: e['thuesuat'],
        ptgiam: e['ptgiam'],
        loaikm: e['loaikm'],
        msctkm: e['msctkm'],
        url: e['url'],
        tenctkm: e['tenctkm'],
        dieukien2: e['dieukien2'],
        theodon: e['theodon'],
        sodangky: e['sodangky'],
        mshh_mua: e['mshh_mua'],
        groupproduct: e['groupproduct'],
      );
    }).toList();
    return lists;
  }

  static Future<List> listHotItems_egpp(params) async {
    var headers = {
      'Authorization':
          'bearer eyJ0eXAi.iJKV1QiLCJhbGci.iJIUzI1NiJ9OeyJtc2R2IjoiMjIwMjIwMTA1NDA2MzciLCJtc2RuIjoiMDkwNzY3.DIzNCIsInRlbmR2IjoiTkhcdTAwYzAgVEhVXHUxZWQwQyBBTiBUXHUwMGMyTSIsImV4cGlyZWQi.jE3MDk2NTE1MDB9OaIWRy7MMe9EF_QpAar-_qFA.SStlFm4NriftyIcNkzU',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://egpp.vn/api_tmdt/list_nhapkho'));
    request.body = json.encode({"msdv": "22022010540637", "soluong": 20});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<List<GiaSanPham>> load_hosogiaban(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse((api + '/hanghoa/load_hosogiaban')));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;

    final lists = res.map((e) {
      return GiaSanPham(
        sl_tuden: e['sl_tuden'],
        dvt_ban: e['dvt_ban'],
        giaban: e['giaban'],
      );
    }).toList();
    return lists;
  }

  static Future<List<MoTaSanPham>> listmotasp(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse((api + '/hanghoa/listmotasp')));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;

    final lists = res.map((e) {
      return MoTaSanPham(
        chidinh: e['chidinh'],
        chongchidinh: e['chongchidinh'],
        lieudung: e['lieudung'],
        tacdungphu: e['tacdungphu'],
        thantrong: e['thantrong'],
        tuongtacthuoc: e['tuongtacthuoc'],
        baoquan: e['baoquan'],
      );
    }).toList();
    return lists;
  }

  static Future<List<SanPham>> loadAllProductGroups(params) async {
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request(
        'POST', Uri.parse((api + '/hanghoa/list_toanbo_hanghoa_theonhom')));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;

    final lists = res.map((e) {
      return SanPham(
        mshh: e['mshh'],
        tenhh: e['tenhh'],
        path_image: e['path_image'],
        path_image_child: e['path_image_child'],
        hamluong: e['hamluong'],
        tenhoatchat: e['tenhoatchat'],
        tennhom: e['tennhom'],
        quycach: e['quycach'],
        standard: e['standard'],
        tennhasx: e['tennhasx'],
        country: e['country'],
        tim: e['tim'],
        chitu: e['chitu'],
        mshhnpp: e['mshhnpp'],
        mshhncc: e['mshhncc'],
        dvt: e['dvtmin'],
        msnpp: e['msnpp'],
        pttichluy: e['pttichluy'],
        thuesuat: e['thuesuat'],
        ptgiam: e['ptgiam'],
        loaikm: e['loaikm'],
        msctkm: e['msctkm'],
        url: e['url'],
        tenctkm: e['tenctkm'],
        dieukien2: e['dieukien2'],
        theodon: e['theodon'],
        sodangky: e['sodangky'],
        mshh_mua: e['mshh_mua'],
        groupproduct: e['groupproduct'],
      );
    }).toList();
    return lists;
  }

  static Future<List<SanPham>> list_sanphamcungnhom(params) async {
    var headers = {'Content-Type': 'application/json'};

    var request = http.Request(
        'POST', Uri.parse((api + '/hanghoa/list_sanphamcungnhom')));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;

    final lists = res.map((e) {
      return SanPham(
        mshh: e['mshh'],
        tenhh: e['tenhh'],
        path_image: e['path_image'],
        path_image_child: e['path_image_child'],
        hamluong: e['hamluong'],
        tenhoatchat: e['tenhoatchat'],
        tennhom: e['tennhom'],
        quycach: e['quycach'],
        standard: e['standard'],
        tennhasx: e['tennhasx'],
        country: e['country'],
        tim: e['tim'],
        chitu: e['chitu'],
        mshhnpp: e['mshhnpp'],
        mshhncc: e['mshhncc'],
        dvt: e['dvtmin'],
        msnpp: e['msnpp'],
        pttichluy: e['pttichluy'],
        thuesuat: e['thuesuat'],
        ptgiam: e['ptgiam'],
        loaikm: e['loaikm'],
        msctkm: e['msctkm'],
        url: e['url'],
        tenctkm: e['tenctkm'],
        dieukien2: e['dieukien2'],
        theodon: e['theodon'],
        sodangky: e['sodangky'],
        mshh_mua: e['mshh_mua'],
        groupproduct: e['groupproduct'],
      );
    }).toList();
    return lists;
  }

  static Future<void> updateTim(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(api + '/hanghoa/update_tim'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    await request.send();
  }

  static Future<List> getTim(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(api + '/hanghoa/get_tim'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;

    return res;
  }
}
