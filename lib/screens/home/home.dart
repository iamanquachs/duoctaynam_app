import 'dart:async';
import 'dart:math';

import 'package:app_dtn/model/cart_model.dart';
import 'package:app_dtn/model/filter_model.dart';
import 'package:app_dtn/model/user_model.dart';
import 'package:app_dtn/screens/cart/cart.dart';
import 'package:app_dtn/screens/history/history.dart';
import 'package:app_dtn/screens/history/otp.dart';
import 'package:app_dtn/screens/history/verify.dart';
import 'package:app_dtn/screens/home/SearchPage.dart';
import 'package:app_dtn/screens/home/list_nhom_giatot.dart';
import 'package:app_dtn/screens/home/modal_login.dart';
import 'package:app_dtn/screens/home/order_product.dart';
import 'package:app_dtn/screens/pay/pay.dart';
import 'package:app_dtn/screens/product/all_product_banchay.dart';
import 'package:app_dtn/screens/product/sanpham_detail.dart';
import 'package:app_dtn/services/cart_services.dart';
import 'package:app_dtn/services/hanghoa_services.dart';
import 'package:app_dtn/services/history_services.dart';
import 'package:app_dtn/services/user_services.dart';
import 'package:app_dtn/screens/product/sanpham_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../model/danhmuc_model.dart';
import '../../model/hanghoa_model.dart';
import '../../services/danhmuc_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_dtn/router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class CountCart extends GetxController {
  var soluong = 0.obs;
  RxString msdn = ''.obs;
  RxString tendv = ''.obs;

  Future<void> setMSDN() async {
    final prefs = await SharedPreferences.getInstance();

    final local_msdn = prefs.getString('msdn') ?? '';
    final local_tendv = prefs.getString('tendv') ?? '';
    msdn.value = local_msdn;
    tendv.value = local_tendv;
  }

  Future<void> handleListCart() async {
    final prefs = await SharedPreferences.getInstance();
    final msdn = prefs.getString('msdn') ?? '';
    var params = {"msdn": msdn};
    final res = await ListCartApi.listGioHang(params);
    soluong.value = (res.length);
  }

  RxList<SanPham> listbanchay = List<SanPham>.from([]).obs;
  RxList<SanPham> listHotItems = List<SanPham>.from([]).obs;

  Future<void> handleListBanChay() async {
    listHotItems.value = [];
    listbanchay.value = [];
    final prefs = await SharedPreferences.getInstance();
    final local_msdn = prefs.getString('msdn') ?? '';
    if (local_msdn == '') {
    } else {
      var body = {"msnhom": '', "offset": "", "limit": ""};
      final dataSever = await HangHoa.listAllHanghoa(body);
      var params = {"mshh": "", "soluong": "15"};
      final dataUser = await HangHoa.listHotItems_egpp(params);
      if (dataSever != '' && dataUser != '') {
        dataUser.forEach((itemUser) {
          final sodangkyUser = itemUser['sodangky'];
          final tenhhUser = itemUser['tenhh'];
          final mshhnccUser = itemUser['mshhncc'];
          final hoatchatchinhUser = itemUser['hoatchatchinh'];
          dataSever.forEach((itemSever) {
            final sodangkySever = itemSever.sodangky;
            final tenhhSever = itemSever.tenhh;
            final mshhnccSever = itemSever.mshhncc;
            final hoatchatchinhSever = itemSever.tenhoatchat;
            if (mshhnccUser == mshhnccSever && mshhnccUser != '') {
              listbanchay.add(itemSever);
            } else {
              if (sodangkyUser == sodangkySever && sodangkyUser != "") {
                listbanchay.add(itemSever);
              }
              if (sodangkyUser != sodangkySever &&
                  tenhhUser != "" &&
                  (tenhhSever.toUpperCase())
                          .contains(tenhhUser.toUpperCase()) ==
                      true) {
                listbanchay.add(itemSever);
              }
              if (sodangkyUser != sodangkySever &&
                  tenhhUser != "" &&
                  hoatchatchinhUser != "" &&
                  (hoatchatchinhSever.toUpperCase())
                          .contains(hoatchatchinhUser.toUpperCase()) ==
                      true) {
                listbanchay.add(itemSever);
              }
            }
          });
        });
      } else {
        var params = {"mshh": "", "soluong": "15"};
        final res = await HangHoa.listHotItems(params);
        listbanchay.value = res;
      }
    }
  }

  Future<void> loadHotItems() async {
    await handleListBanChay();

    var itemDaco = listbanchay.length;
    var itemConLai = 15 - itemDaco;
    var mshh = '';
    for (int i = 0; i < itemDaco; i++) {
      mshh += listbanchay[i].mshh + ",";
    }
    if (itemDaco == 15) {
      listHotItems = listbanchay;
    } else {
      List<SanPham> allListHotItem = [];

      if (itemConLai != 0) {
        allListHotItem = listbanchay;

        var params = {"soluong": itemConLai, "mshh": mshh};
        final res = await HangHoa.listHotItems(params);

        for (int i = 0; i < res.length; i++) {
          allListHotItem.add(res[i]);
        }
        listHotItems.value = allListHotItem;
      }
    }
  }
}

class _HomeState extends State<Home> {
  final loadGetx = Get.put(CountCart());
  final ScrollController _controller = ScrollController();

  final CountCart other = Get.find();
  List<SanPham> listnoibat = [];
  List<SanPham> listFilter = [];
  List<ListNhom> listNhom = [];
  List<ListNhom> listNuocSX = [];
  List<ListNhom> listNhaSX = [];
  List<User> egpp = [];
  List ktraEGPP = [];
  List<UserDtn> dtn = [];
  String sodienthoai = "";
  String msdn = "";
  String otp = "";
  String valueSearch = "";
  var tientichluy = 0;
  var nhom = [];
  var hang = [];
  var nuoc = [];
  final current = new NumberFormat("#,##0", "en_US");
  var link_banner = "https://erp.duoctaynam.vn/upload/banner/";

  var link_pdf = "https://erp.duoctaynam.vn/upload/pdf/";

  var top_l = [];
  var top_r = [];
  var mid_l = [];
  var mid_r = [];

  @override
  void initState() {
    super.initState();
    handleListNoiBat();
    handleListNhom();
    handleListNuocSX();
    handleListNhaSX();
    loadGetx.setMSDN();
    loadGetx.handleListCart();
    loadGetx.loadHotItems();
    loadTienTichLuy();
    KtraUserEGPP();
    loadBanner();
    openMessage();
    CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  }

  void openMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final message = prefs.getString('message') ?? '0';
    if (message == '0') {
      _showMessage();
    }
  }

  void _scrollTop() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  FutureOr<Iterable> handleSearch(query) async {
    List matches = [];

    if (query == "") {
      await Future<void>.delayed(Duration(seconds: 1));

      setState(() {
        valueSearch = '';
      });
    } else {
      var params = {
        "value": query,
      };
      final res = await HangHoa.listSearch(params);
      matches.addAll(res);
      setState(() {
        valueSearch = query;
      });
    }
    return matches;
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await loadGetx.setMSDN();
    loadGetx.loadHotItems();
  }

  Future<void> handleListNoiBat() async {
    var params = {"msdv": "", "soluong": "15"};
    final res = await HangHoa.listNoiBat(params);
    setState(() {
      listnoibat = res;
    });
  }

  Future<void> handleListNhom() async {
    var params = {"phanloai": "groupproduct"};
    final res = await ListNhomApi.listNhom(params);
    setState(() {
      listNhom = res;
    });
  }

  Future<void> handleListNuocSX() async {
    var params = {"phanloai": "country"};
    final res = await ListNhomApi.listNhom(params);
    setState(() {
      listNuocSX = res;
    });
  }

  Future<void> handleListNhaSX() async {
    var params = {"phanloai": "producer"};
    final res = await ListNhomApi.listNhom(params);
    setState(() {
      listNhaSX = res;
    });
  }

  Future<void> loadTienTichLuy() async {
    final prefs = await SharedPreferences.getInstance();
    final msdv = prefs.getString('msdv') ?? '';
    var params = {"mskh": msdv};
    final res_tichluy = await ListCartApi.loadtientichluy(params);
    setState(() {
      tientichluy = int.parse(res_tichluy[0]['sotien']);
    });
  }

  Future<void> KtraUserEGPP() async {
    final prefs = await SharedPreferences.getInstance();
    final dienthoai = prefs.getString('dienthoai') ?? '';
    var params = {"sdt": dienthoai};
    final res = await HistoryApi.KtraUserEGPP(params);
    setState(() {
      ktraEGPP = res;
    });
  }

  handleFilter(type, e) async {
    switch (type) {
      case 'nhom':
        if (nhom.contains("'" + e + "'") == true) {
          setState(() {
            nhom.remove("'" + e + "'");
          });
        } else {
          setState(() {
            nhom.add("'" + e + "'");
          });
        }
        break;
      case 'hang':
        if (hang.contains("'" + e + "'") == true) {
          setState(() {
            hang.remove("'" + e + "'");
          });
        } else {
          setState(() {
            hang.add("'" + e + "'");
          });
        }
        break;
      case 'nuoc':
        if (nuoc.contains("'" + e + "'") == true) {
          setState(() {
            nuoc.remove("'" + e + "'");
          });
        } else {
          setState(() {
            nuoc.add("'" + e + "'");
          });
        }
        break;
      case 'clear':
        setState(() {
          nhom = [];
          hang = [];
          nuoc = [];
        });
    }
    final filter = Filter(
      groupproduct: nhom,
      producer: hang,
      standard: [],
      country: nuoc,
    );

    var params = (filter);
    final res = await HangHoa.listFilter(params);
    if (nhom.length > 0 || hang.length > 0 || nuoc.length > 0) {
      setState(() {
        listFilter = res;
      });
    } else {
      setState(() {
        listFilter = [];
      });
    }
  }

  handleOpenHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final _otp = prefs.getString('otp') ?? '';
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ktraEGPP.length != 0 || _otp != '' ? History() : OTP()),
    );
  }

  Future<void> loadBanner() async {
    var params = {};
    final res = await Login.loadBanner(params);
    for (int i = 0; i < res.length; i++) {
      // print(res[i]['vitri_header']);
      if (res[i]['vitri_header'] == 'TOP_L') {
        setState(() {
          top_l.add(res[i]['path_image']);
        });
      }
      if (res[i]['vitri_header'] == 'TOP_R') {
        setState(() {
          top_r.add(res[i]['path_image']);
        });
      }
      if (res[i]['vitri_header'] == 'MID_L') {
        setState(() {
          mid_l.add(res[i]['path_image']);
        });
      }
      if (res[i]['vitri_header'] == 'MID_R') {
        setState(() {
          mid_r.add(res[i]['path_image']);
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 60,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 0, 121, 36),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Row(
                          children: [
                            if (other.msdn != '')
                              Container(
                                  width: 224,
                                  child: Text(
                                    other.tendv.toString(),
                                    style: TextStyle(
                                        color: Color(0xffffffff),
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                          ],
                        ),
                      ),
                      Builder(
                        builder: (context) => // Ensure Scaffold is in context
                            IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.close,
                                  color: Color(0xffffffff),
                                ),
                                onPressed: () =>
                                    Scaffold.of(context).closeDrawer()),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 180, 180, 180)))),
                child: const ListTile(
                  title: Text('Trang chủ'),
                ),
              ),
              Obx(
                () => Column(
                  children: [
                    if (other.msdn != '')
                      Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Color.fromARGB(
                                            255, 180, 180, 180)))),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text('Tiền tích lũy: '),
                                  Text(
                                    current
                                        .format(
                                            int.parse(tientichluy.toString()))
                                        .replaceAll(',', '.'),
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 255, 0, 0)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Color.fromARGB(
                                            255, 180, 180, 180)))),
                            child: ListTile(
                              title: const Text('Lịch sử đơn hàng'),
                              onTap: () {
                                handleOpenHistory();
                              },
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Color.fromARGB(
                                            255, 180, 180, 180)))),
                            child: ListTile(
                              title: const Text('Yêu cầu tìm sản phẩm'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OrderProduct()),
                                );
                              },
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: Color.fromARGB(
                                            255, 180, 180, 180)))),
                            child: ListTile(
                                title: TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(50, 30),
                                  alignment: Alignment.centerLeft),
                              onPressed: () {
                                logout();
                              },
                              child: Text(
                                'Đăng xuất',
                                style: TextStyle(color: Color(0xff0000000)),
                              ),
                            )),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          controller: _controller,
          children: <Widget>[
            StickyHeader(
              header: Container(
                margin: EdgeInsets.only(bottom: 10),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      decoration: const BoxDecoration(color: Color(0xffffffff)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 50,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Builder(
                                  builder:
                                      (context) => // Ensure Scaffold is in context
                                          IconButton(
                                              icon: Icon(
                                                Icons.menu,
                                                size: 30,
                                              ),
                                              onPressed: () =>
                                                  Scaffold.of(context)
                                                      .openDrawer()),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Color(0xFFF5F9FD),
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xFFF475269)
                                              .withOpacity(0.3),
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ]),
                                child: Stack(children: [
                                  Positioned(
                                      child: InkWell(
                                    onTap: () {
                                      handleFilter('clear', '');
                                    },
                                    child: Image.asset(
                                      'images/banners/Logo_TPSPharma_mini.png',
                                    ),
                                  )),
                                  Container(
                                    padding: EdgeInsets.only(left: 50),
                                    width: 250,
                                    child: TypeAheadFormField(
                                      getImmediateSuggestions: false,
                                      textFieldConfiguration:
                                          const TextFieldConfiguration(
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Tìm kiếm...'),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return handleSearch(pattern);
                                      },
                                      itemBuilder: (context, suggestion) {
                                        if (valueSearch == '') {
                                          return Text('');
                                        } else {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SanPhamDetail(
                                                          detail: [suggestion],
                                                        )),
                                              );
                                            },
                                            child: ListTile(
                                              leading: Image.network(
                                                'https://erp.duoctaynam.vn/upload/sanpham/' +
                                                    suggestion.path_image,
                                              ),
                                              title: Text(suggestion.tenhh),
                                              subtitle: Text(suggestion.chitu),
                                            ),
                                          );
                                        }
                                      },
                                      itemSeparatorBuilder: (context, index) {
                                        return Divider();
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        // this._typeAheadController.text = '';
                                      },
                                      suggestionsBoxDecoration:
                                          SuggestionsBoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        elevation: 2.0,
                                        color: Theme.of(context).cardColor,
                                      ),
                                    ),
                                  ),
                                  if (valueSearch != '')
                                    Positioned(
                                        right: 0,
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SearchPage(
                                                          valueSearch:
                                                              valueSearch,
                                                        )),
                                              );
                                            },
                                            icon: Icon(
                                                Icons.arrow_forward_rounded)))
                                ]),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Obx(
                                () => Column(children: [
                                  if (other.msdn != '')
                                    Row(children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Cart()),
                                          );
                                        },
                                        child: Expanded(
                                          child: Stack(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(7),
                                                child: Icon(
                                                  Icons.shopping_bag_outlined,
                                                  size: 30,
                                                  color: Color(0xff0000000),
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 255, 0, 0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: Obx(
                                                    () => Text(
                                                      '${other.soluong}',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xfffffffff),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ])
                                  else
                                    TextButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return Container(
                                                  child: ModalLogin(),
                                                );
                                              });
                                        },
                                        child: Image.asset(
                                            'images/icons/account.png'))
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 33,
                      decoration: BoxDecoration(color: Color(0xff103c19)),
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            for (int n = 1; n < listNhom.length; n++)
                              Row(children: [
                                TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(nhom
                                                      .contains("'" +
                                                          listNhom[n].msloai +
                                                          "'") ==
                                                  true
                                              ? Color.fromARGB(
                                                  255, 249, 100, 67)
                                              : Color(0xff103c19))),
                                  child: Text(
                                    listNhom[n].tenloai,
                                    style: const TextStyle(
                                        color: Color(0xffffffff), fontSize: 13),
                                  ),
                                  onPressed: () {
                                    handleFilter('nhom', listNhom[n].msloai);
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                )
                              ]),
                          ]),
                    ),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(color: Color(0xffffffff)),
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            for (int n = 1; n < listNhaSX.length; n++)
                              Center(
                                child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              hang.contains("'" +
                                                          listNhaSX[n].msloai +
                                                          "'") ==
                                                      true
                                                  ? Color.fromARGB(
                                                      255, 249, 100, 67)
                                                  : Color.fromARGB(
                                                      255, 255, 255, 255))),
                                  child: Text(
                                    listNhaSX[n].tenloai,
                                    style: TextStyle(
                                        color: hang.contains("'" +
                                                    listNhaSX[n].msloai +
                                                    "'") ==
                                                true
                                            ? Color(0xffffffff)
                                            : Color(0xff0000000),
                                        fontSize: 12),
                                  ),
                                  onPressed: () {
                                    handleFilter('hang', listNhaSX[n].msloai);
                                  },
                                ),
                              ),
                          ]),
                    ),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(color: Color(0xffffffff)),
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            for (int n = 1; n < listNuocSX.length; n++)
                              Center(
                                child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              nuoc.contains("'" +
                                                          listNuocSX[n].msloai +
                                                          "'") ==
                                                      true
                                                  ? Color.fromARGB(
                                                      255, 249, 100, 67)
                                                  : Color.fromARGB(
                                                      255, 255, 255, 255))),
                                  child: Text(
                                    listNuocSX[n].tenloai,
                                    style: TextStyle(
                                        color: nuoc.contains("'" +
                                                    listNuocSX[n].msloai +
                                                    "'") ==
                                                true
                                            ? Color(0xffffffff)
                                            : Color(0xff0000000),
                                        fontSize: 12),
                                  ),
                                  onPressed: () {
                                    handleFilter('nuoc', listNuocSX[n].msloai);
                                  },
                                ),
                              ),
                          ]),
                    ),
                  ],
                ),
              ),
              content: Container(
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 150,
                              autoPlay: true,
                              viewportFraction: 1,
                            ),
                            items: top_l.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      width: double.infinity,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Image(
                                          image: CachedNetworkImageProvider(
                                        link_banner + i,
                                      )));
                                },
                              );
                            }).toList(),
                          ),
                          Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                for (int i = 0; i < top_r.length; i++)
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Image(
                                        image: CachedNetworkImageProvider(
                                      link_banner + top_r[i],
                                    )),
                                  )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    if (listFilter.length > 0)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                child: Row(
                              children: [
                                SizedBox(
                                  width: 25,
                                  child: Image.asset('images/icons/title.png'),
                                ),
                                const Text(
                                  'Danh sách lọc',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )),
                            // OutlinedButton(
                            //   style: OutlinedButton.styleFrom(
                            //     backgroundColor: Colors.green[100],
                            //     primary: Colors.white,
                            //     side: const BorderSide(
                            //         width: 1,
                            //         color: Color.fromRGBO(161, 233, 161, 1)),
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(30.0),
                            //     ),
                            //   ),
                            //   onPressed: () {},
                            //   child: const Text(
                            //     'Xem tất cả',
                            //     style: TextStyle(color: Color(0xff000000)),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    if (listFilter.length > 0)
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              for (final sanpham in listFilter)
                                Sanpham(sanpham: sanpham)
                            ],
                          )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 25,
                                child: Image.asset('images/icons/title.png'),
                              ),
                              const Text(
                                'Sản phẩm bán chạy',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.green[100],
                              primary: Colors.white,
                              side: const BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(161, 233, 161, 1)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllProductBanChay()),
                              );
                            },
                            child: const Text(
                              'Xem tất cả',
                              style: TextStyle(color: Color(0xff000000)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Obx(
                      () => Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              for (final sanpham in other.listHotItems)
                                Sanpham(sanpham: sanpham)
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 150,
                              autoPlay: true,
                              viewportFraction: 1,
                            ),
                            items: mid_l.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      width: double.infinity,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Image(
                                          image: CachedNetworkImageProvider(
                                        link_banner + i,
                                      )));
                                },
                              );
                            }).toList(),
                          ),
                          Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                for (int i = 0; i < mid_r.length; i++)
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Image(
                                        image: CachedNetworkImageProvider(
                                      link_banner + top_r[i],
                                    )),
                                  )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 25,
                                child: Image.asset('images/icons/title.png'),
                              ),
                              const Text(
                                'Sản phẩm nổi bật',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )),
                          // OutlinedButton(
                          //   style: OutlinedButton.styleFrom(
                          //     backgroundColor: Colors.green[100],
                          //     primary: Colors.white,
                          //     side: const BorderSide(
                          //         width: 1,
                          //         color: Color.fromRGBO(161, 233, 161, 1)),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(30.0),
                          //     ),
                          //   ),
                          //   onPressed: () {},
                          //   child: const Text(
                          //     'Xem tất cả',
                          //     style: TextStyle(color: Color(0xff000000)),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            for (final sanpham in listnoibat)
                              Sanpham(sanpham: sanpham)
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Row(
                                children: [
                                  SizedBox(
                                    width: 25,
                                    child:
                                        Image.asset('images/icons/title.png'),
                                  ),
                                  const Text(
                                    'Sản phẩm giá tốt',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              for (final nhomsanpham in listNhom)
                                NhomGiaTot(nhomsanpham: nhomsanpham)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
          width: double.infinity,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
            color: Color(0xfffffffffff),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 4,
                offset: Offset(1, 2), // Shadow position
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: Image.asset('images/icons/Chu_TNP.png'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 30,
                          child: InkWell(
                            onTap: () {
                              launch("tel://+84901090917");
                            },
                            child: Image.asset('images/icons/call.png'),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                          child: InkWell(
                              onTap: () {
                                launch("https://zalo.me/4210793912768709606");
                              },
                              child: Image.asset('images/icons/zalo.png')),
                        ),
                        SizedBox(
                          width: 30,
                          child: InkWell(
                              onTap: () {
                                launch("https://www.facebook.com/duoctaynam");
                              },
                              child: Image.asset('images/icons/fb.png')),
                        ),
                        SizedBox(
                          width: 30,
                          child: InkWell(
                              onTap: () {
                                Share.share('https://duoctaynam.vn/');
                              },
                              child: Image.asset('images/icons/share.png')),
                        ),
                        SizedBox(
                          width: 30,
                          child: InkWell(
                            onTap: () {
                              _scrollTop();
                            },
                            child: Image.asset('images/icons/top.png'),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

//!Modal login

  Future<void> _showMessage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'THÔNG TIN QUAN TRỌNG',
            style: TextStyle(color: Color.fromARGB(241, 218, 7, 7)),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: const Column(
                children: [
                  Text(
                    '     Công ty Cổ phần Dược Tây Nam được Công ty TNHH Công nghệ Phần mềm TPSoft thành lập và phát triển nhằm khẳng định sự nỗ lực không ngừng xây dựng hệ sinh thái hoàn chỉnh với sứ mệnh đem đến cho khách hàng những giá trị thiết thực, sự trải nghiệm hoàn toàn mới và khác biệt.',
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '     Với tất cả lòng nhiệt huyết và khát khao, chúng tôi vinh dự được cung cấp sản phẩm và dịch vụ đến tất cả các Nhà thuốc, Quầy thuốc, Phòng khám đang hoạt động trên cả nước.',
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '     Chúng tôi luôn tôn trọng và bảo vệ cộng đồng, vì thế tất cả thông tin về sản phẩm đều nhằm mục đích cung cấp thông tin cho người có chuyên môn theo quy định của pháp luật. Việc sử dụng thuốc kê đơn hay thuốc chữa bệnh phải tuyệt đối tuân thủ theo sự hướng dẫn của người có chuyên môn về y dược.',
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Trân trọng cảm ơn.',
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Dược Tây Nam © by TPSoft',
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
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
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();

                  Navigator.of(context).pop();
                  await prefs.setString('message', '1');
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
