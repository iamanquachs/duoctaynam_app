import 'package:app_dtn/screens/product/sanpham_items.dart';

import '../../model/hanghoa_model.dart';

import 'package:app_dtn/services/hanghoa_services.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.valueSearch});
  final String valueSearch;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List listSearch = [];
  @override
  void initState() {
    super.initState();
    searchHanghoa();
  }

  searchHanghoa() async {
    var params = {
      "value": widget.valueSearch,
    };
    final res = await HangHoa.listSearch(params);
    setState(() {
      listSearch = res;
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
        title: Text('Tìm kiếm'),
        backgroundColor: Color(0xff103c19),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(5),
            child: Column(
              children: [
                for (final sanpham in listSearch) Sanpham(sanpham: sanpham)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
