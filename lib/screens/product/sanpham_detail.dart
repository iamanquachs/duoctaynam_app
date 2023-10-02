import 'dart:math';

import 'package:app_dtn/model/hanghoa_model.dart';
import 'package:app_dtn/screens/home/home.dart';
import 'package:app_dtn/services/dathang_services.dart';
import 'package:app_dtn/services/hanghoa_services.dart';
import 'package:app_dtn/screens/product/sanpham_items.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_dtn/screens/home/modal_login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class SanPhamDetail extends StatefulWidget {
  const SanPhamDetail({super.key, required this.detail});
  final List detail;
  @override
  State<SanPhamDetail> createState() => _SanPhamDetailState();
}

class _SanPhamDetailState extends State<SanPhamDetail> {
  final soluongCart = Get.put(CountCart());
  final ScrollController _controller = ScrollController();
  List<String> list_image_child = [];
  List<GiaSanPham> hosogiaban = [];
  List<MoTaSanPham> mota = [];
  List<SanPham> list_sanphamcungnhom = [];
  String tenhoatchat_a = '';
  var soluong = 1;
  final current = new NumberFormat("#,##0", "en_US");
  var msdn = "";

  @override
  void initState() {
    super.initState();
    handleTachImageChild();
    handleGiaBan();
    loadLocal_MSDN();
    handleMota();
    load_sanphamlienquan();
  }

  Future<void> loadLocal_MSDN() async {
    final prefs = await SharedPreferences.getInstance();
    final local_msdn = prefs.getString('msdn') ?? '';
    setState(() {
      msdn = local_msdn;
    });
  }

  dathangLine_add() {
    if (msdn != '') {
      handleKiemtraGiohang() async {
        var params = {"msdn": msdn, "mshh": widget.detail[0].mshh};
        final ktra_giohang = await DatHang.handleKtraCart(params);
        if (ktra_giohang.length == 0) {
          var params = {
            "msdv": "",
            "msdn": msdn,
            "mshh": widget.detail[0].mshh,
            "tenhh": widget.detail[0].tenhh,
            "mshhnpp": widget.detail[0].mshhnpp,
            "dvt": widget.detail[0].dvt,
            "msnpp": widget.detail[0].msnpp,
            "pttichluy": widget.detail[0].pttichluy,
            "thuesuat": widget.detail[0].thuesuat,
            "soluong": soluong,
            "gianhap": 0,
            "ptgiam": widget.detail[0].ptgiam,
            "msctkm": widget.detail[0].msctkm,
          };
          await DatHang.handleDathangLine(params);
          soluongCart.handleListCart();
        } else {
          var soluongNew = int.parse(ktra_giohang[0].soluong) + soluong;
          var params = {
            "msdv": "",
            "msdn": msdn,
            "mshh": widget.detail[0].mshh,
            "tenhh": widget.detail[0].tenhh,
            "mshhnpp": widget.detail[0].mshhnpp,
            "dvt": widget.detail[0].dvt,
            "msnpp": widget.detail[0].msnpp,
            "pttichluy": widget.detail[0].pttichluy,
            "thuesuat": widget.detail[0].thuesuat,
            "soluong": soluongNew,
            "gianhap": 0,
            "ptgiam": widget.detail[0].ptgiam,
            "msctkm": widget.detail[0].msctkm,
          };
          await DatHang.handleUpdateDathangLine(params);
        }
      }

      handleKiemtraGiohang();
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return Container(
              width: 500,
              child: ModalLogin(),
            );
          });
    }
  }

  soluong_tang() {
    setState(() {
      soluong += 1;
    });
  }

  soluong_giam() {
    setState(() {
      soluong -= 1;
    });
  }

  Future<void> handleTachImageChild() async {
    var image_child = widget.detail[0].path_image_child;
    setState(() {
      list_image_child = image_child.split('|');
    });
  }

  Future<void> handleGiaBan() async {
    var params = {
      "mshh": widget.detail[0].mshh,
    };
    final res = await HangHoa.load_hosogiaban(params);
    setState(() {
      hosogiaban = res;
    });
  }

  Future<void> handleMota() async {
    var params = {
      "mshh": widget.detail[0].mshh,
    };
    final res = await HangHoa.listmotasp(params);
    setState(() {
      mota = res;
    });
  }

  Future<void> load_sanphamlienquan() async {
    var params = {
      "tru_hanghoa": widget.detail[0].url,
      "value_msnhom": widget.detail[0].groupproduct,
    };
    final res = await HangHoa.list_sanphamcungnhom(params);
    print(res);
    setState(() {
      list_sanphamcungnhom = res;
    });
  }

  void _scrollTop() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff103c19),
        centerTitle: true,
        title: const Text(
          'Chi tiết sản phẩm',
          style: TextStyle(color: Color(0xfffffffff)),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: const Icon(
              Icons.more_horiz_outlined,
              color: Color(0xfffffffff),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          controller: _controller,
          child: Column(
            children: [
              Column(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color(0xffffffff),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.detail[0].tenhh,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 6, 117, 23),
                                    fontSize: 22,
                                  ),
                                ),
                                Container(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          child: Image(
                                            image: CachedNetworkImageProvider(
                                                'https://erp.duoctaynam.vn/upload/sanpham/${widget.detail[0].path_image}'),
                                          ),
                                        )
                                      ],
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      child: InkWell(
                                          child: Image(
                                        image: CachedNetworkImageProvider(
                                            'https://erp.duoctaynam.vn/upload/sanpham/${widget.detail[0].path_image}'),
                                      )),
                                    ),
                                    for (int i = 0;
                                        i < list_image_child.length;
                                        i++)
                                      if (list_image_child[i] != '')
                                        Container(
                                          width: 80,
                                          height: 80,
                                          child: InkWell(
                                              child: Image(
                                            image: CachedNetworkImageProvider(
                                                'https://erp.duoctaynam.vn/upload/anhmota/' +
                                                    list_image_child[i]),
                                          )),
                                        ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 130,
                                            child: Text(
                                              '● Nhóm',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Text(
                                            widget.detail[0].tennhom,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            width: 130,
                                            child: Text(
                                              '● Hoạt chất',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              width: 150,
                                              padding: EdgeInsets.only(top: 3),
                                              child: Text(
                                                parseFragment(widget
                                                        .detail[0].tenhoatchat)
                                                    .text
                                                    .toString(),
                                                style: const TextStyle(
                                                    height: 1, fontSize: 16),
                                                softWrap: true,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 130,
                                            child: Text(
                                              '● Hàm lượng',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Text(
                                            widget.detail[0].hamluong,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 130,
                                            child: Text(
                                              '● Quy cách',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Text(
                                            widget.detail[0].quycach,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 130,
                                            child: Text(
                                              '● Tiêu chuẩn',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Text(
                                            widget.detail[0].standard,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 130,
                                            child: Text(
                                              '● Nhà sản xuất',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Text(
                                            widget.detail[0].tennhasx,
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 130,
                                            child: Text(
                                              '● Nước sản xuất',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Text(
                                            widget.detail[0].country,
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Container(
                                    width: 300,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 227, 255, 229),
                                    ),
                                    child: Column(
                                      children: [
                                        for (int i = 0;
                                            i < hosogiaban.length;
                                            i++)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 10),
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1,
                                                        color: Color.fromARGB(
                                                            255,
                                                            197,
                                                            197,
                                                            197)))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  hosogiaban[i].sl_tuden +
                                                      ' ' +
                                                      hosogiaban[i].dvt_ban,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                Text(
                                                    '${current.format(int.parse(hosogiaban[i].giaban)).replaceAll(',', '.')}/${hosogiaban[i].dvt_ban}',
                                                    style:
                                                        TextStyle(fontSize: 20))
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 80,
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                flex: 5,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            onPressed: () {
                                                              soluong_giam();
                                                            },
                                                            icon: Icon(
                                                                Icons.remove)),
                                                        Container(
                                                          width: 40,
                                                          height: 40,
                                                          child: TextFormField(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              textAlignVertical:
                                                                  TextAlignVertical
                                                                      .center,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText: soluong
                                                                      .toString(),
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              12))),
                                                        ),
                                                        IconButton(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            onPressed: () {
                                                              soluong_tang();
                                                            },
                                                            icon: Icon(
                                                                Icons.add)),
                                                      ]),
                                                )),
                                            Expanded(
                                              child: SizedBox(
                                                width: 1,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: SizedBox(
                                                width: 200,
                                                height: 40,
                                                child: ElevatedButton(
                                                  child: Text(
                                                    'Thêm vào giỏ',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.green,
                                                  ),
                                                  onPressed: () {
                                                    dathangLine_add();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              ]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (mota.length != 0)
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: const Color(0xffffffff),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (mota[0].chidinh != '')
                                    const Stack(
                                      children: [
                                        Positioned(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                        DecoratedBox(
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                'CHỈ ĐỊNH',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromARGB(
                                                        255, 0, 103, 15)),
                                              ),
                                            ))
                                      ],
                                    ),
                                  Container(
                                    child: Text(parseFragment(mota[0].chidinh)
                                        .text
                                        .toString()),
                                  ),
                                  if (mota[0].chongchidinh != '')
                                    const Stack(
                                      children: [
                                        Positioned(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                        DecoratedBox(
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                'CHỐNG CHỈ ĐỊNH',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromARGB(
                                                        255, 0, 103, 15)),
                                              ),
                                            ))
                                      ],
                                    ),
                                  Container(
                                    child: Text(
                                        parseFragment(mota[0].chongchidinh)
                                            .text
                                            .toString()),
                                  ),
                                  if (mota[0].lieudung != '')
                                    const Stack(
                                      children: [
                                        Positioned(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                        DecoratedBox(
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                'LIỀU DÙNG',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromARGB(
                                                        255, 0, 103, 15)),
                                              ),
                                            ))
                                      ],
                                    ),
                                  Container(
                                    child: Text(parseFragment(mota[0].lieudung)
                                        .text
                                        .toString()),
                                  ),
                                  if (mota[0].tacdungphu != '')
                                    const Stack(
                                      children: [
                                        Positioned(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                        DecoratedBox(
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                'TÁC DỤNG PHỤ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromARGB(
                                                        255, 0, 103, 15)),
                                              ),
                                            ))
                                      ],
                                    ),
                                  Container(
                                    child: Text(
                                        parseFragment(mota[0].tacdungphu)
                                            .text
                                            .toString()),
                                  ),
                                  if (mota[0].thantrong != '')
                                    const Stack(
                                      children: [
                                        Positioned(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                        DecoratedBox(
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                'THẬN TRỌNG',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromARGB(
                                                        255, 0, 103, 15)),
                                              ),
                                            ))
                                      ],
                                    ),
                                  Container(
                                    child: Text(parseFragment(mota[0].thantrong)
                                        .text
                                        .toString()),
                                  ),
                                  if (mota[0].tuongtacthuoc != '')
                                    const Stack(
                                      children: [
                                        Positioned(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                        DecoratedBox(
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                'TƯƠNG TÁC THUỐC',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromARGB(
                                                        255, 0, 103, 15)),
                                              ),
                                            ))
                                      ],
                                    ),
                                  Container(
                                    child: Text(
                                        parseFragment(mota[0].tuongtacthuoc)
                                            .text
                                            .toString()),
                                  ),
                                  if (mota[0].baoquan != '')
                                    const Stack(
                                      children: [
                                        Positioned(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                        DecoratedBox(
                                            decoration: const BoxDecoration(
                                                color: Colors.white),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                'BẢO QUẢN',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color.fromARGB(
                                                        255, 0, 103, 15)),
                                              ),
                                            ))
                                      ],
                                    ),
                                  Container(
                                    child: Text(parseFragment(mota[0].baoquan)
                                        .text
                                        .toString()),
                                  ),
                                ]),
                          ),
                      ]),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Sản phẩm cùng nhóm',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                width: double.infinity,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Column(children: [
                  for (final sanpham in list_sanphamcungnhom)
                    Sanpham(sanpham: sanpham)
                ]),
              )
            ],
          )),
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
                                Share.share(
                                    'https://duoctaynam.vn/product?${widget.detail[0].url}');
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
}
