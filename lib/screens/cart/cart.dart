import 'dart:convert';
import 'dart:math';

import 'package:app_dtn/model/cart_model.dart';
import 'package:app_dtn/screens/home/home.dart';
import 'package:app_dtn/screens/pay/pay.dart';
import 'package:app_dtn/services/cart_services.dart';
import 'package:app_dtn/screens/cart/cart_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class CartList extends GetxController {
  RxInt tongtien = 0.obs;
  RxList<ListCart> listCart = List<ListCart>.from([]).obs;
  RxList<ListCart> listOther = List<ListCart>.from([]).obs;

  Future<void> handleListCart(e) async {
    final prefs = await SharedPreferences.getInstance();
    final msdn = prefs.getString('msdn') ?? '';
    var body = {"msdn": msdn};
    final res = await ListCartApi.listGioHang(body);
    listCart.value = res;
    if (e == true) {
      var request = 0;
      for (int i = 0; i < res.length; i++) {
        request += int.parse(res[i].thanhtienvat);
      }
      tongtien.value = request;
      listOther.value = res;
    } else {}
  }
}

class _CartState extends State<Cart> {
  final current = NumberFormat("#,##0", "en_US");
  final cartItem = Get.put(CartList());
  final CartList other = Get.find();
  final soluongCart = Get.put(CountCart());
  late IO.Socket socket;
  var URI_SERVER = 'http://notication.duoctaynam.vn:3001';

  var tientichluy = 0;
  var loaitichluy = false;
  var tenvoucher = '';
  var mavoucher = '';
  var sotienvoucher = 0;
  var tongtien = 0;
  var thanhtoan = 0;
  var msdv = '';
  var msdn = '';
  var dienthoai = '';
  var tendv = '';
  var tendaidien = '';
  var diachi = '';
  var maxa = '';
  var chitietnhanhang = '';
  var sodienthoainhanhang = '';
  var diachinhanhang = '';
  String selectTinh = '';
  List listTinh = [
    {'matinh': '', 'tentinh': 'Tỉnh'}
  ];
  String selectHuyen = '';
  List listHuyen = [
    {'mahuyen': '', 'tenhuyen': 'Huyện'}
  ];
  String selectXa = '';
  List listXa = [
    {'maxa': '', 'tenxa': 'Xã'}
  ];
  String selectVoucher = '';
  List itemsVoucher = [
    {'mavoucher': '', 'sotien': 0, 'tenvoucher': 'Chọn mã quà tặng'},
  ];

  String selectThongtin = '';
  var itemsThongtin = [];

  @override
  void initState() {
    super.initState();
    add_hanghoa_km();
    handleLoadTichLuy();
    handleListVoucher();
    cartItem.handleListCart(true);
    loadThongTin();
    socketIO();
  }

  add_hanghoa_km() async {
    final prefs = await SharedPreferences.getInstance();
    final msdn = prefs.getString('msdn') ?? '';
    var params = {'msdn': msdn};
    await ListCartApi.add_hanghoa_km(params);
    soluongCart.handleListCart();
  }

  void socketIO() {
    socket = IO.io(URI_SERVER, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true
    });
  }

  Future<void> loadThongTin() async {
    final prefs = await SharedPreferences.getInstance();
    final setmsdv = prefs.getString('msdv') ?? '';
    final setmsdn = prefs.getString('msdn') ?? '';
    final setdienthoai = prefs.getString('dienthoai') ?? '';
    final settendv = prefs.getString('tendv') ?? '';
    final settendaidien = prefs.getString('tendaidien') ?? '';
    final setdiachi = prefs.getString('diachi') ?? '';
    final setmaxa = prefs.getString('msxa') ?? '';
    setState(() {
      msdv = setmsdv;
      msdn = setmsdn;
      dienthoai = setdienthoai;
      tendv = settendv;
      tendaidien = settendaidien;
      diachi = setdiachi;
      maxa = setmaxa;
    });

    handleThongTinNhanHang();
  }

  handleThongTinNhanHang() async {
    int random(int min, int max) {
      return min + Random().nextInt(max - min);
    }

    var rand = random(1000, 9999);
    var body;
    if (msdn != '') {
      body = {
        "msdv": msdv,
        "masonguoinhan": dienthoai + rand.toString(),
        "tenkhachhang": tendv,
        "hotennguoinhan": tendaidien,
        "sodienthoai": dienthoai,
        "diachi": diachi,
        "tinh": '',
        "huyen": '',
        "xa": '',
        "maxa": maxa,
      };
    } else {
      body = {
        "msdv": dienthoai,
        "masonguoinhan": dienthoai + rand.toString(),
        "tenkhachhang": tendv,
        "hotennguoinhan": tendaidien,
        "sodienthoai": dienthoai,
        "diachi": diachi,
        "tinh": '',
        "huyen": '',
        "xa": '',
        "maxa": maxa,
      };
    }

    final res = await ListCartApi.listThongTinNhanHang(body);
    var macdinh = '';
    setState(() {
      itemsThongtin = res;
      for (int i = 0; i < res.length; i++) {
        if (res[i]['macdinh'] == '1') {
          macdinh = (res[i]['masonguoinhan']);
          chitietnhanhang = (res[i]['masonguoinhan']);
        }
      }
      selectThongtin = macdinh;
    });
    loadChitietNhanhang();
  }

  Future<void> loadChitietNhanhang() async {
    for (int i = 0; i < itemsThongtin.length; i++) {
      if (itemsThongtin[i]['masonguoinhan'] == chitietnhanhang) {
        setState(() {
          sodienthoainhanhang = itemsThongtin[i]['sodienthoai'];
          diachinhanhang = itemsThongtin[i]['diachi'];
        });
      }
    }
  }

  Future<void> handleLoadTichLuy() async {
    final prefs = await SharedPreferences.getInstance();
    final msdv = prefs.getString('msdv') ?? '';
    var params = {"mskh": msdv};
    final res = await ListCartApi.loadtientichluy(params);
    setState(() {
      tientichluy = int.parse(res[0]['sotien']);
    });
  }

  Future<void> handleListVoucher() async {
    final prefs = await SharedPreferences.getInstance();
    final msdv = prefs.getString('msdv') ?? '';
    var params = {"msdv": msdv};
    final res = await ListCartApi.listVoucher(params);
    setState(() {
      itemsVoucher.addAll(res);
    });
  }

  void deleteCart() async {
    final prefs = await SharedPreferences.getInstance();
    final msdn = prefs.getString('msdn') ?? '';
    var params = {"msdn": msdn};
    await ListCartApi.deleteCartAll(params);
    cartItem.handleListCart('');
    soluongCart.handleListCart();
    Navigator.of(context).pop();
  }

  handleThanhtoan() async {
    DateTime now = new DateTime.now();
    DateTime getdate = new DateTime(now.year, now.month, now.day);
    var rnd = Random();
    var date =
        getdate.toString().replaceAll("00:00:00.000", "").replaceAll('-', '');
    var code = rnd.nextInt(9000) + 1000;
    final prefs = await SharedPreferences.getInstance();
    final msdv = prefs.getString('msdv') ?? '';
    final msdn = prefs.getString('msdn') ?? '';
    final tendv = prefs.getString('tendv') ?? '';
    final tendaidien = prefs.getString('tendaidien') ?? '';
    final diachi = prefs.getString('diachi') ?? '';
    final dienthoai = prefs.getString('dienthoai') ?? '';
    var soct = ('DH' + date + code.toString()).replaceAll(' ', '');
    var thanhtienvat = ((cartItem.tongtien.value -
                sotienvoucher -
                (loaitichluy == true ? tientichluy : 0)) >
            0
        ? (cartItem.tongtien.value -
            sotienvoucher -
            (loaitichluy == true ? tientichluy : 0))
        : 0);
    var params = {};
    if (msdv != '') {
      params = {
        'msdv': "",
        'msdn': msdn,
        'mskh': msdv,
        'tenkhachhang': tendv,
        'tendaidien': tendaidien,
        'dienthoai': dienthoai,
        'diachi': diachi,
        'soct': soct,
        'mavoucher': mavoucher,
        'tenvoucher': tenvoucher,
        'loaitichluy': loaitichluy,
        'tientichluy': tientichluy,
        'sotienvoucher': sotienvoucher,
        'thanhtienvat': thanhtienvat,
      };
    } else {
      params = {
        'msdv': "",
        'msdn': msdn,
        'mskh': dienthoai,
        'tenkhachhang': tendv,
        'tendaidien': tendaidien,
        'dienthoai': dienthoai,
        'diachi': diachi,
        'soct': soct,
        'mavoucher': mavoucher,
        'tenvoucher': tenvoucher,
        'loaitichluy': loaitichluy,
        'tientichluy': tientichluy,
        'sotienvoucher': sotienvoucher,
        'thanhtienvat': thanhtienvat,
      };
    }

    if (diachi != '') {
      if (other.listOther.length != 0) {
        await ListCartApi.Add_DathangHeader(params);
        for (var i = 0; i < other.listOther.length; i++) {
          var params = {
            'msdn': msdn,
            'soct': soct,
            'rowid': other.listOther[i].rowid,
          };
          await ListCartApi.update_dathangLine_1(params);
        }
        soluongCart.handleListCart();
        socket.emit('donhang');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Pay(soct: soct)),
        );
      }
    }
  }

  deleteThongtin(e) async {
    var params = {'masonguoinhan': e};
    await ListCartApi.deleteThongTin(params);
    handleThongTinNhanHang();
  }

  editThongtin(e) async {
    var params = {'masonguoinhan': e, 'msdv': msdv == '' ? dienthoai : msdv};
    await ListCartApi.editThongtin(params);
    handleThongTinNhanHang();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff103c19),
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Đặt hàng',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              color: Color(0xffeeebeb),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffffffff),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Đặt hàng",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 0, 0),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              TextButton(
                                  onPressed: () {
                                    _ModaldeleteCart();
                                  },
                                  child: const Text(
                                    'Xóa tất cả',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 41, 152, 0),
                                        fontSize: 18),
                                  ))
                            ],
                          ),
                          Container(
                            child: Obx(
                              () => Container(
                                child: Column(children: [
                                  for (final itemCart in other.listCart)
                                    if (int.parse(itemCart.ptgiam) < 100 &&
                                        int.parse(itemCart.spctkm) == 0)
                                      CartItem(
                                        itemCart: itemCart,
                                        checked: true,
                                      )
                                ]),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Chiết khấu thêm",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 0, 0),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Container(
                            child: Obx(
                              () => Container(
                                child: Column(children: [
                                  for (final itemCart in other.listCart)
                                    if (int.parse(itemCart.spctkm) == 1 &&
                                        int.parse(itemCart.ptgiam) < 100)
                                      CartItem(
                                        itemCart: itemCart,
                                        checked: true,
                                      )
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffffffff),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Khách hàng',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: Column(children: [
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      width: 20,
                                      child:
                                          Image.asset('images/icons/home.png'),
                                    ),
                                  ),
                                  Text(
                                    tendv,
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      width: 20,
                                      child:
                                          Image.asset('images/icons/user.png'),
                                    ),
                                  ),
                                  Text(
                                    tendaidien,
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      width: 20,
                                      child:
                                          Image.asset('images/icons/phone.png'),
                                    ),
                                  ),
                                  Text(
                                    dienthoai,
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      width: 20,
                                      child: Image.asset(
                                          'images/icons/address.png'),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    diachi,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 16),
                                  ))
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 90,
                                    child: Text(
                                      'Thông tin nhận hàng',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    width: 170,
                                    child: Column(
                                      children: <Widget>[
                                        if (itemsThongtin.length > 0)
                                          DropdownButton(
                                            value: selectThongtin == ''
                                                ? null
                                                : selectThongtin,
                                            isDense: true,
                                            isExpanded: true,
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            items: itemsThongtin.map((item) {
                                              return DropdownMenuItem(
                                                value: item['masonguoinhan']
                                                    .toString(),
                                                child: Text(
                                                  item['hotennguoinhan']
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectThongtin =
                                                    newValue.toString();
                                                chitietnhanhang =
                                                    newValue.toString();
                                              });
                                              loadChitietNhanhang();
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return Container(
                                                width: 500,
                                                child: ModalAddThongTin(
                                                  callBackThongTin:
                                                      handleThongTinNhanHang,
                                                ),
                                              );
                                            });
                                      },
                                      icon:
                                          const Icon(Icons.add_circle_outline),
                                    ),
                                  ),
                                  SizedBox(
                                      width: 30,
                                      child: IconButton(
                                          onPressed: () {
                                            _ModalThongtinNhanhang();
                                          },
                                          icon: const Icon(Icons.edit)))
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 130,
                                    child: Text(
                                      'Số điện thoại',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    sodienthoainhanhang,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 16),
                                  ))
                                ],
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 130,
                                    child: Text(
                                      'Địa chỉ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    diachinhanhang,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 16),
                                  ))
                                ],
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffffffff),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Tổng tiền',
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 255, 0, 0),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        child: Obx(
                                          () => Text(
                                            current
                                                    .format(int.parse(cartItem
                                                        .tongtien.value
                                                        .toString()))
                                                    .replaceAll(',', '.') +
                                                ' đ',
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 0, 0),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ]),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Mã quà tặng',
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 255, 0, 0),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        width: 160,
                                        child: Column(
                                          children: <Widget>[
                                            if (itemsVoucher.length > 0)
                                              DropdownButton(
                                                hint: Text('Chọn mã quà tặng'),
                                                value: selectVoucher == ''
                                                    ? null
                                                    : selectVoucher,
                                                isDense: true,
                                                isExpanded: true,
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items: itemsVoucher.map((item) {
                                                  return DropdownMenuItem(
                                                    value: item['mavoucher']
                                                            .toString() +
                                                        '|' +
                                                        item['sotien']
                                                            .toString() +
                                                        '|' +
                                                        item['tenvoucher']
                                                            .toString(),
                                                    child: Text(
                                                        item['tenvoucher']
                                                            .toString()),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  var chitietVoucher =
                                                      newValue != null
                                                          ? newValue.split('|')
                                                          : [];
                                                  setState(() {
                                                    selectVoucher =
                                                        newValue.toString();
                                                    sotienvoucher = int.parse(
                                                        chitietVoucher[1]);
                                                    tenvoucher =
                                                        chitietVoucher[2];
                                                    mavoucher =
                                                        chitietVoucher[0];
                                                  });
                                                },
                                              ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        current
                                                .format(sotienvoucher)
                                                .replaceAll(',', '.')
                                                .toString() +
                                            ' đ',
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 255, 0, 0),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Tiền tích lũy',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: loaitichluy,
                                            checkColor: Colors.white,
                                            shape: CircleBorder(),
                                            onChanged: (bool? value) {
                                              setState(() {
                                                loaitichluy = value!;
                                              });
                                            },
                                          ),
                                          Text(
                                            '${current.format(int.parse((tientichluy).toString())).replaceAll(',', '.')}' +
                                                ' đ',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Thanh toán',
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 255, 0, 0),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        child: Obx(
                                          () => Text(
                                            current
                                                    .format(int.parse(((cartItem
                                                                        .tongtien
                                                                        .value -
                                                                    sotienvoucher -
                                                                    (loaitichluy ==
                                                                            true
                                                                        ? tientichluy
                                                                        : 0)) >
                                                                0
                                                            ? (cartItem.tongtien
                                                                    .value -
                                                                sotienvoucher -
                                                                (loaitichluy ==
                                                                        true
                                                                    ? tientichluy
                                                                    : 0))
                                                            : 0)
                                                        .toString()))
                                                    .replaceAll(',', '.') +
                                                ' đ',
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 0, 0),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ]),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 35,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                        onPrimary: Colors
                                            .white, // Text Color (Foreground color)
                                      ),
                                      onPressed: () {
                                        handleThanhtoan();
                                      },
                                      child: const Text(
                                        'Đặt hàng',
                                        style: TextStyle(fontSize: 18),
                                      )),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _ModalThongtinNhanhang() async {
    return showDialog<void>(
      context: context,

      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width + 100,
          ),
          title: Container(
            child: Column(children: [
              Text(
                'Danh sách thông tin nhận hàng',
              ),
              Container(
                child: Column(children: [
                  for (int i = 0; i < itemsThongtin.length; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            itemsThongtin[i]['hotennguoinhan'],
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: TextButton(
                                  onPressed: () {
                                    deleteThongtin(
                                        itemsThongtin[i]['masonguoinhan']);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Xóa',
                                      style: TextStyle(
                                        color: Color(0xff0000000),
                                      ))),
                            ),
                            SizedBox(
                              width: 80,
                              child: itemsThongtin[i]['macdinh'] == '0'
                                  ? TextButton(
                                      onPressed: () {
                                        editThongtin(
                                            itemsThongtin[i]['masonguoinhan']);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Mặc định',
                                        style:
                                            TextStyle(color: Color(0xff000000)),
                                      ),
                                    )
                                  : const Text(
                                      'Đã mặc định',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 3, 127, 52)),
                                    ),
                            )
                          ],
                        )
                      ],
                    )
                ]),
              )
            ]),
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 224, 224, 224)),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15)),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 16, color: Colors.black))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Đóng',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
          ],
        );
      },
    );
  }

  Future<void> _ModaldeleteCart() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Xóa tất cả',
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 203, 14, 0)),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15)),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 16, color: Colors.white))),
                onPressed: () {
                  deleteCart();
                },
                child: const Text('Đồng ý')),
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 224, 224, 224)),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15)),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 16, color: Colors.black))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Đóng',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
          ],
        );
      },
    );
  }
}

class ModalAddThongTin extends StatefulWidget {
  const ModalAddThongTin({super.key, required this.callBackThongTin});
  final Function callBackThongTin;
  @override
  _ModalAddThongTinState createState() => new _ModalAddThongTinState();
}

class _ModalAddThongTinState extends State<ModalAddThongTin> {
  final loadCartThongTin = _CartState();
  String tennguoinhan = '';
  String diachinguoinhan = '';
  String sodienthoainguoinhan = '';
  String selectTinh = '';
  List listTinh = [
    {'matinh': '', 'tentinh': 'Tỉnh'}
  ];
  String selectHuyen = '';
  List listHuyen = [
    {'mahuyen': '', 'tenhuyen': 'Huyện'}
  ];
  String selectXa = '';
  List listXa = [
    {'maxa': '', 'tenxa': 'Xã'}
  ];
  @override
  void initState() {
    super.initState();
    handleLoadTinh();
  }

  handleLoadTinh() async {
    var params = {'msdv': ''};
    final res = await ListCartApi.loadDMTinh(params);
    setState(() {
      listTinh.addAll(res);
    });
  }

  handleLoadHuyen(e) async {
    var params = {'mstinh': e};
    final res = await ListCartApi.loadDMHuyen(params);
    setState(() {
      listHuyen.addAll(res);
    });
  }

  handleLoadXa(e) async {
    var params = {'mshuyen': e};
    final res = await ListCartApi.loadDMXa(params);
    setState(() {
      listXa.addAll(res);
    });
  }

  add_thongtinnhanhang() async {
    final prefs = await SharedPreferences.getInstance();
    var random = Random().nextInt(9000) + 1000;
    final msdv = prefs.getString('msdv') ?? '';
    final msdn = prefs.getString('msdn') ?? '';
    final tendv = prefs.getString('tendv') ?? '';
    final msxa = prefs.getString('msxa') ?? '';
    final msnn = sodienthoainguoinhan + random.toString();
    var params = {};
    if (msdv != '') {
      params = {
        'msdv': msdv,
        'masonguoinhan': msnn,
        'tenkhachhang': tendv,
        'hotennguoinhan': tennguoinhan,
        'sodienthoai': sodienthoainguoinhan,
        'diachi': diachinguoinhan,
        'tinh': selectTinh.split('|')[1],
        'huyen': selectHuyen.split('|')[1],
        'xa': selectXa.split('|')[1],
        'maxa': msxa,
      };
    } else {
      params = {
        'msdv': msdn,
        'masonguoinhan': msnn,
        'tenkhachhang': tendv,
        'hotennguoinhan': tennguoinhan,
        'sodienthoai': sodienthoainguoinhan,
        'diachi': diachinguoinhan,
        'tinh': selectTinh.split('|')[1],
        'huyen': selectHuyen.split('|')[1],
        'xa': selectXa.split('|')[1],
        'maxa': msxa,
      };
    }
    if (tennguoinhan != '' &&
        sodienthoainguoinhan != '' &&
        diachinguoinhan != '' &&
        selectXa != '') {
      await ListCartApi.add_thongtinnhanhang(params);
      Navigator.of(context).pop();
      widget.callBackThongTin();
    }
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width + 100,
      ),
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.all(10),
      insetPadding: EdgeInsets.all(10),
      title: Container(
        child: Column(children: [
          Text(
            'Thêm thông tin nhận hàng',
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(children: [
              SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tên người nhận',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 9, 130, 79)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: TextField(
                            onChanged: (e) {
                              setState(() {
                                tennguoinhan = e;
                              });
                            },
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                hintText: 'Tên người nhận')),
                      ),
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Số điện thoại',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 9, 130, 79)),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: TextField(
                            keyboardType: TextInputType.phone,
                            onChanged: (e) {
                              setState(() {
                                sodienthoainguoinhan = e;
                              });
                            },
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                hintText: 'Số điện thoại')),
                      ),
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Địa chỉ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 9, 130, 79)),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: TextField(
                            onChanged: (e) {
                              setState(() {
                                diachinguoinhan = e;
                              });
                            },
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                hintText: 'Số nhà')),
                      ),
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 200,
                child: Column(
                  children: <Widget>[
                    if (listTinh.length > 0)
                      DropdownButton(
                        hint: Text('Tỉnh'),
                        value: selectTinh == '' ? null : selectTinh,
                        isDense: true,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                        ),
                        items: listTinh.map((item) {
                          return DropdownMenuItem(
                            value: item['matinh'].toString() +
                                '|' +
                                item['tentinh'].toString(),
                            child: Text(
                              item['tentinh'].toString(),
                              style: TextStyle(fontSize: 13),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          var value = newValue.toString().split('|');
                          setState(() {
                            selectTinh = newValue.toString();
                          });
                          handleLoadHuyen(value[0]);
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (selectTinh != '')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      child: Column(
                        children: <Widget>[
                          if (listHuyen.length > 0)
                            DropdownButton(
                              hint: Text('Huyện'),
                              value: selectHuyen == '' ? null : selectHuyen,
                              isDense: true,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: listHuyen.map((item) {
                                return DropdownMenuItem(
                                  value: item['mahuyen'].toString() +
                                      '|' +
                                      item['tenhuyen'].toString(),
                                  child: Text(
                                    item['tenhuyen'].toString(),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                var value = newValue.toString().split('|')[0];
                                setState(() {
                                  selectHuyen = newValue.toString();
                                });
                                handleLoadXa(value);
                              },
                            ),
                        ],
                      ),
                    ),
                    Container(
                      width: 150,
                      child: Column(
                        children: <Widget>[
                          if (listXa.length > 0)
                            DropdownButton(
                              hint: Text('Xã'),
                              value: selectXa == '' ? null : selectXa,
                              isDense: true,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: listXa.map((item) {
                                return DropdownMenuItem(
                                  value: item['maxa'].toString() +
                                      '|' +
                                      item['tenxa'].toString(),
                                  child: Text(
                                    item['tenxa'].toString(),
                                    style: TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectXa = newValue.toString();
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                )
            ]),
          )
        ]),
      ),
      actions: <Widget>[
        ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
                backgroundColor:
                    MaterialStateProperty.all(Color.fromARGB(255, 2, 116, 33)),
                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 16, color: Colors.black))),
            onPressed: () {
              add_thongtinnhanhang();
            },
            child: const Text(
              'Thêm',
              style: TextStyle(fontSize: 16, color: Colors.white),
            )),
        ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 224, 224, 224)),
                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 16, color: Colors.black))),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Đóng',
              style: TextStyle(fontSize: 16, color: Colors.black),
            )),
      ],
    );
  }
}
