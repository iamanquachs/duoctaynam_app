import 'package:app_dtn/model/hanghoa_model.dart';
import 'package:app_dtn/screens/home/home.dart';
import 'package:app_dtn/screens/home/modal_login.dart';
import 'package:app_dtn/screens/product/sanpham_detail.dart';
import 'package:app_dtn/services/dathang_services.dart';
import 'package:app_dtn/services/hanghoa_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class Sanpham extends StatefulWidget {
  const Sanpham({super.key, required this.sanpham});
  final SanPham sanpham;

  @override
  State<Sanpham> createState() => _SanphamState();
}

class _SanphamState extends State<Sanpham> {
  var soluong = 1;
  var msdn = "";
  var tim = 0;
  var api = "https://api.duoctaynam.vn";
  final soluongCart = Get.put(CountCart());

  @override
  void initState() {
    super.initState();
    CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
    loadLocal_MSDN();
    get_tim();
  }

  dathangLine_add() {
    if (msdn != '') {
      handleKiemtraGiohang() async {
        var params = {"msdn": msdn, "mshh": widget.sanpham.mshh};
        final ktra_giohang = await DatHang.handleKtraCart(params);
        if (ktra_giohang.length == 0) {
          var params = {
            "msdv": "",
            "msdn": msdn,
            "mshh": widget.sanpham.mshh,
            "tenhh": widget.sanpham.tenhh,
            "mshhnpp": widget.sanpham.mshhnpp,
            "dvt": widget.sanpham.dvt,
            "msnpp": widget.sanpham.msnpp,
            "pttichluy": widget.sanpham.pttichluy,
            "thuesuat": widget.sanpham.thuesuat,
            "soluong": soluong,
            "gianhap": 0,
            "ptgiam": widget.sanpham.ptgiam,
            "msctkm": widget.sanpham.msctkm,
          };
          await DatHang.handleDathangLine(params);
          soluongCart.handleListCart();
        } else {
          var soluongNew = int.parse(ktra_giohang[0].soluong) + soluong;
          var params = {
            "msdv": "",
            "msdn": msdn,
            "mshh": widget.sanpham.mshh,
            "tenhh": widget.sanpham.tenhh,
            "mshhnpp": widget.sanpham.mshhnpp,
            "dvt": widget.sanpham.dvt,
            "msnpp": widget.sanpham.msnpp,
            "pttichluy": widget.sanpham.pttichluy,
            "thuesuat": widget.sanpham.thuesuat,
            "soluong": soluongNew,
            "gianhap": 0,
            "ptgiam": widget.sanpham.ptgiam,
            "msctkm": widget.sanpham.msctkm,
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

  Future<void> loadLocal_MSDN() async {
    final prefs = await SharedPreferences.getInstance();
    final local_msdn = prefs.getString('msdn') ?? '';
    setState(() {
      msdn = local_msdn;
    });
  }

  Future<void> get_tim() async {
    var params = {'mshh': widget.sanpham.mshh};
    final res = await HangHoa.getTim(params);
    setState(() {
      tim = int.parse(res[0]['tim_all']);
    });
  }

  update_tim() async {
    final timnew = tim + 1;
    var params = {'mshh': widget.sanpham.mshh, 'timnew': timnew};
    await HangHoa.updateTim(params);
    get_tim();
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (widget.sanpham.loaikm == '1') ...[
          if (widget.sanpham.ptgiam != 0) ...[
            Container(
                margin: EdgeInsets.only(bottom: 5),
                padding: EdgeInsets.only(bottom: 5),
                height: 30,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 203, 202, 202)))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.sanpham.tenctkm,
                      style: TextStyle(color: Color(0xff008000), fontSize: 18),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Color(0xffEB0000),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        '-${widget.sanpham.ptgiam}%',
                        style: TextStyle(
                            color: Color(0xfffffffff),
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )),
          ] else ...[
            SizedBox(
              width: 1,
            )
          ]
        ] else ...[
          if (widget.sanpham.mshh_mua == '') ...[
            Container(
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.only(bottom: 5),
              height: 30,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 203, 202, 202)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      // width: 200,
                      margin: EdgeInsets.only(left: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Color(0xffEB0000),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        '${widget.sanpham.tenctkm}',
                        style: TextStyle(
                          color: Color(0xfffffffff),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ] else ...[
            SizedBox(
              width: 1,
            )
          ]
        ],
        SizedBox(
          height: 44,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SanPhamDetail(
                          detail: [widget.sanpham],
                        )),
              );
            },
            child: Text(
              widget.sanpham.tenhh,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF008000)),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 180,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SanPhamDetail(
                              detail: [widget.sanpham],
                            )),
                  );
                },
                child: Image(
                  image: CachedNetworkImageProvider(
                    'https://erp.duoctaynam.vn/upload/sanpham/' +
                        widget.sanpham.path_image,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 20,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '● ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Text(
                                    parseFragment(widget.sanpham.tenhoatchat)
                                        .text
                                        .toString(),
                                    style: TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ]),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '● ' + widget.sanpham.tennhom,
                            style: const TextStyle(fontSize: 16),
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis, // new
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '● ' + widget.sanpham.quycach,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '● ' + widget.sanpham.standard,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '● ' + widget.sanpham.tennhasx,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '● ' + widget.sanpham.country,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    )
                  ]),
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: 30,
                    child: InkWell(
                      onTap: () {
                        update_tim();
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icons/heart.png',
                            width: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            tim.toString(),
                            style: TextStyle(color: Color(0xff000000)),
                          ),
                        ],
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'images/icons/price.png',
                      width: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.sanpham.chitu,
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
        Container(
          width: double.infinity,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            soluong_giam();
                          },
                          icon: Icon(Icons.remove)),
                      Container(
                        width: 50,
                        height: 30,
                        child: TextFormField(
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: soluong.toString(),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10))),
                      ),
                      IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            soluong_tang();
                          },
                          icon: Icon(Icons.add)),
                    ]),
              ),
            ),
            const Expanded(
              child: SizedBox(
                width: 1,
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                child: Column(children: [
                  ElevatedButton(
                    child: Text('Thêm vào giỏ'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        minimumSize:
                            const Size.fromHeight(30) // Background color
                        ),
                    onPressed: () {
                      dathangLine_add();
                    },
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
