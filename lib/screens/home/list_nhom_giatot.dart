import 'package:app_dtn/model/danhmuc_model.dart';
import 'package:app_dtn/model/hanghoa_model.dart';
import 'package:app_dtn/screens/product/all_product_nhom.dart';
import 'package:app_dtn/services/hanghoa_services.dart';
import 'package:app_dtn/screens/product/sanpham_items.dart';
import 'package:flutter/material.dart';

class NhomGiaTot extends StatefulWidget {
  const NhomGiaTot({super.key, required this.nhomsanpham});
  final ListNhom nhomsanpham;
  @override
  State<NhomGiaTot> createState() => _NhomGiaTotState();
}

class _NhomGiaTotState extends State<NhomGiaTot> {
  List<SanPham> listgiatot = [];

  @override
  void initState() {
    super.initState();
    handleListGiaTot();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          if (listgiatot.length > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '●',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 160, 24),
                                fontSize: 20),
                          ),
                          Expanded(
                            child: Text(widget.nhomsanpham.tenloai,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                ),
                                softWrap: false,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green[100],
                    primary: Colors.white,
                    side: const BorderSide(
                        width: 1, color: Color.fromRGBO(161, 233, 161, 1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllProductGroups(
                                msnhom: widget.nhomsanpham.dieukien2,
                                tennhom: widget.nhomsanpham.tenloai,
                              )),
                    );
                  },
                  child: const Text(
                    'Xem tất cả',
                    style: TextStyle(color: Color(0xff000000)),
                  ),
                )
              ],
            ),
          Container(
            width: double.infinity,
            child: Column(children: [
              for (final sanpham in listgiatot) Sanpham(sanpham: sanpham)
            ]),
          )
        ],
      ),
    );
  }

  Future<void> handleListGiaTot() async {
    var body = {
      "msnhom": widget.nhomsanpham.msloai,
      "offset": "0",
      "limit": "10"
    };
    final res = await HangHoa.listAllHanghoa(body);
    setState(() {
      listgiatot = res;
    });
  }
}
