import 'package:app_dtn/model/cart_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String api = 'https://api.duoctaynam.vn';

class ListCartApi {
  static Future<List<ListCart>> listGioHang(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(api + '/giohang/listgiohang'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res =
        json.decode(await response.stream.bytesToString()) as List<dynamic>;
    final lists = res.map((e) {
      return ListCart(
        rowid: e['rowid'],
        mshh: e['mshh'],
        tenhh: e['tenhh'],
        giagoc: e['giagoc'],
        dvt: e['dvt'],
        soluong: e['soluong'],
        thanhtien: e['thanhtien'],
        ptgiam: e['ptgiam'],
        thanhtienvat: e['thanhtienvat'],
        path_image: e['path_image'],
        spctkm: e['spctkm'],
      );
    }).toList();
    return lists;
  }

  static Future<List> loadtientichluy(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/giohang/load_tien_tichluy'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<List> listVoucher(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/giohang/list_voucher'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<List> listThongTinNhanHang(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/giohang/listthongtinnhanhang'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());
    return res;
  }

  static Future<void> deleteItemCart(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/dathang/dathangline_delete'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    await request.send();
  }

  static Future<void> deleteCartAll(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/giohang/cart_delete_all'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    await request.send();
  }

  static Future<void> updateGiohang(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/dathang/update_dathangline'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    await request.send();
  }

  static Future<void> Add_DathangHeader(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/thanhtoan/dathangheader_add'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    await request.send();
  }

  static Future<void> update_dathangLine_1(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/thanhtoan/update_line_1'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    await request.send();
  }

  static Future<List> getThanhtienDonhang(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/thanhtoan/get_thanhtien'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<void> deleteThongTin(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/giohang/delete_thongtin'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    await request.send();
  }

  static Future<void> editThongtin(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/giohang/edit_thongtin'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    await request.send();
  }

  static Future<List> loadDMTinh(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/giohang/load_danhmuc_tinh'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<List> loadDMHuyen(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/giohang/load_danhmuc_huyen'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());
    return res;
  }

  static Future<List> loadDMXa(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/giohang/load_danhmuc_xa'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var res = json.decode(await response.stream.bytesToString());

    return res;
  }

  static Future<void> add_thongtinnhanhang(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/giohang/add_thongtinnhanhang'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    await request.send();
  }
  static Future<void> add_hanghoa_km(params) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse(api + '/giohang/add_hanghoa_km'));
    request.body = json.encode(params);
    request.headers.addAll(headers);

    await request.send();
  }
}
