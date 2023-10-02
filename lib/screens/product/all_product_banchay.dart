import 'package:app_dtn/model/hanghoa_model.dart';
import 'package:app_dtn/screens/product/sanpham_items.dart';
import 'package:app_dtn/services/hanghoa_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllProductBanChay extends StatefulWidget {
  const AllProductBanChay({super.key});

  @override
  State<AllProductBanChay> createState() => _AllProductBanChayState();
}

class _AllProductBanChayState extends State<AllProductBanChay> {
  List<SanPham> listAllProduct = [];
  @override
  void initState() {
    super.initState();
    loadHotItems();
  }

  List<SanPham> listbanchay = [];
  List<SanPham> listHotItems = [];

  Future<void> handleListBanChay() async {
    final prefs = await SharedPreferences.getInstance();
    final local_msdn = prefs.getString('msdn') ?? '';
    if (local_msdn == '') {
    } else {
      var body = {"msnhom": '', "offset": "", "limit": ""};
      final dataSever = await HangHoa.listAllHanghoa(body);
      var params = {"mshh": "", "soluong": "20"};
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
        listbanchay = res;
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
        setState(() {
          listHotItems = allListHotItem;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
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
          'Tất cả sản phẩm bán chạy',
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Color(0xff103c19),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(5),
            child: Column(
              children: [
                for (final sanpham in listHotItems) Sanpham(sanpham: sanpham)
              ],
            )),
      )),
    );
  }
}
