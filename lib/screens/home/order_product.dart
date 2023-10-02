import 'package:app_dtn/services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderProduct extends StatefulWidget {
  const OrderProduct({super.key});

  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  List listOrder = [];
  var tensanpham = '';
  var tenhoatchat = '';
  var hamluong = '';
  var nhasanxuat = '';
  var ghichu = '';
  @override
  void initState() {
    super.initState();
    loadListOrder();
  }

  Future<void> loadListOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final msdv = prefs.getString('msdv') ?? '';
    final msdn = prefs.getString('msdn') ?? '';
    var params = {"msdv": msdv, "msdn": msdn};
    final res = await OrderApi.loadListOrder(params);
    setState(() {
      listOrder = res;
    });
  }

  deleteOrder(e) async {
    final prefs = await SharedPreferences.getInstance();
    final msdv = prefs.getString('msdv') ?? '';
    final msdn = prefs.getString('msdn') ?? '';
    var params = {"msdv": msdv, "msdn": msdn, 'rowid': e};
    await OrderApi.deleteOrder(params);
    loadListOrder();
    Navigator.of(context).pop();
  }

  addOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final msdv = prefs.getString('msdv') ?? '';
    final msdn = prefs.getString('msdn') ?? '';
    var params = {
      'msdv': msdv,
      'msdn': msdn,
      'tenhh': tensanpham,
      'tenhc': tenhoatchat,
      'hamluong': hamluong,
      'nhasx': nhasanxuat,
      'ghichu': ghichu,
    };
    await OrderApi.addOrder(params);
    setState(() {
      tensanpham = '';
      tenhoatchat = '';
      hamluong = '';
      nhasanxuat = '';
      ghichu = '';
    });
    loadListOrder();
    Navigator.of(context).pop();
  }

  Future<void> _openURLOrder(e) async {
    final Uri _url = Uri.parse(e);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Widget build(BuildContext context) {
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
        title: Text('Yêu cầu sản phẩm'),
        backgroundColor: Color(0xff103c19),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'TÌM SẢN PHẨM GIÁ TỐT THEO YÊU CẦU',
                  style: TextStyle(
                      color: Color.fromARGB(255, 202, 3, 3),
                      fontSize: 19,
                      fontWeight: FontWeight.w600),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xfffaef4bd),
                  ),
                  child: SizedBox(
                    height: 30,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                      ),
                      onPressed: () {
                        _showFormYeuCau();
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Color(0xff31af91),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Yêu cầu sản phẩm',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                for (int i = 0; i < listOrder.length; i++)
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Stack(children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 120,
                                child: Text(
                                  'Ngày',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(listOrder[i]['ngaygio'])
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 120,
                                child: Text(
                                  'Tên sản phẩm',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(listOrder[i]['tenhh'])
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 120,
                                child: Text(
                                  'Tên hoạt chất',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(listOrder[i]['tenhc'])
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 120,
                                child: Text(
                                  'Hàm lượng',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(listOrder[i]['hamluong'])
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 120,
                                child: Text(
                                  'Nhà sản xuất',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(listOrder[i]['nhasx'])
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 120,
                                child: Text(
                                  'Ghi chú',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(listOrder[i]['ghichu'])
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 120,
                                child: Text(
                                  'Đặt hàng',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                width: 180,
                                height: 30,
                                child: TextButton(
                                  onPressed: () {
                                    _openURLOrder(listOrder[i]['url']);
                                  },
                                  child: Text(
                                    listOrder[i]['url'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ]),
                      ),
                      if (listOrder[i]['url'] == '')
                        Positioned(
                          right: -10,
                          top: -10,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              onPressed: () {
                                _showFormDeleteYeuCau(listOrder[i]['rowid']);
                              },
                              icon: const Icon(
                                Icons.highlight_remove_outlined,
                                color: Color.fromARGB(255, 255, 0, 0),
                              ),
                            ),
                          ),
                        ),
                    ]),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showFormDeleteYeuCau(e) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Xóa yêu cầu sản phẩm',
            style: TextStyle(color: Color.fromARGB(241, 216, 4, 4)),
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 22, 145, 3)),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15)),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 16, color: Colors.black))),
                onPressed: () {
                  deleteOrder(e);
                },
                child: const Text(
                  'Đồng ý',
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

  Future<void> _showFormYeuCau() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            scrollable: true,
            title: const Text(
              'Yêu cầu tìm sản phẩm',
              style: TextStyle(color: Color.fromARGB(242, 40, 169, 0)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: TextField(
                            onChanged: (e) {
                              setState(() {
                                tensanpham = e;
                              });
                            },
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                hintText: 'Tên sản phẩm',
                                hintStyle:
                                    TextStyle(color: Color(0xff0000000)))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: TextField(
                            onChanged: (e) {
                              setState(() {
                                tenhoatchat = e;
                              });
                            },
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                hintText: 'Tên hoạt chất',
                                hintStyle:
                                    TextStyle(color: Color(0xff0000000)))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: TextField(
                            onChanged: (e) {
                              setState(() {
                                hamluong = e;
                              });
                            },
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                hintText: 'Hàm lượng',
                                hintStyle:
                                    TextStyle(color: Color(0xff0000000)))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: TextField(
                            onChanged: (e) {
                              setState(() {
                                nhasanxuat = e;
                              });
                            },
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                hintText: 'Nhà sản xuất',
                                hintStyle:
                                    TextStyle(color: Color(0xff0000000)))),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: TextField(
                            onChanged: (e) {
                              setState(() {
                                ghichu = e;
                              });
                            },
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                hintText: 'Ghi chú',
                                hintStyle:
                                    TextStyle(color: Color(0xff0000000)))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 22, 145, 3)),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(15)),
                      textStyle: MaterialStateProperty.all(
                          const TextStyle(fontSize: 16, color: Colors.black))),
                  onPressed: () {
                    addOrder();
                  },
                  child: const Text(
                    'Đồng ý',
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
          ),
        )
        ;
      },
    );
  }
}
