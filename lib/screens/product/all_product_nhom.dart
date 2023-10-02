import 'package:app_dtn/model/hanghoa_model.dart';
import 'package:app_dtn/screens/product/sanpham_items.dart';
import 'package:app_dtn/services/hanghoa_services.dart';
import 'package:flutter/material.dart';

class AllProductGroups extends StatefulWidget {
  const AllProductGroups(
      {super.key, required this.msnhom, required this.tennhom});
  final msnhom;
  final tennhom;
  @override
  State<AllProductGroups> createState() => _AllProductGroupsState();
}

class _AllProductGroupsState extends State<AllProductGroups> {
  List<SanPham> listAllProduct = [];
  @override
  void initState() {
    super.initState();
    loadAllProduct();
  }

  Future<void> loadAllProduct() async {
    var params = {
      "value_msnhom": widget.msnhom,
    };
    final res = await HangHoa.loadAllProductGroups(params);
    setState(() {
      listAllProduct = res;
    });
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
          'Tất cả sản phẩm ${widget.tennhom}',
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
                for (final sanpham in listAllProduct) Sanpham(sanpham: sanpham)
              ],
            )),
      )),
    );
  }
}
