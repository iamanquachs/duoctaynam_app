import 'package:app_dtn/screens/history/hitory_item.dart';
import 'package:app_dtn/services/cart_services.dart';
import 'package:app_dtn/services/history_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  var tientichluy = 0;
  var chuathanhtoan = 0;
  final current = NumberFormat("#,##0", "en_US");
  List listItemHistory = [];
  List listChitietTichluy = [];
  var valueSearch = '';
  @override
  String thanhtoan = 'Thanh toán';
  var itemsthanhtoan = [
    'Thanh toán',
    'Đã thanh toán',
    'Chưa thanh toán',
  ];
  String trangthai = 'Trạng thái';
  var itemstrangthai = [
    'Trạng thái',
    'Đặt hàng',
    'Đã duyệt',
    'Đang giao',
    'Đã nhận',
  ];
  TextEditingController tungay = TextEditingController();
  TextEditingController dengay = TextEditingController();

  void initState() {
    DateTime today = DateTime.now();
    String dateTungay =
        "${today.day < 10 ? '0' + today.day.toString() : today.day}-${today.month < 10 ? '0' + (today.month - 3).toString() : today.month - 3}-${today.year}";
    String dateDenngay =
        "${today.day < 10 ? '0' + today.day.toString() : today.day}-${today.month < 10 ? '0' + today.month.toString() : today.month}-${today.year}";

    tungay.text = dateTungay;
    dengay.text = dateDenngay;
    super.initState();
    loadTienTichLuy();
    loadChitietLichSu();
  }

  Future<void> loadChitietLichSu() async {
    final prefs = await SharedPreferences.getInstance();
    final msdv = prefs.getString('msdv') ?? '';
    final tach_tungay = tungay.text.split('-');
    final tach_dengay = dengay.text.split('-');
    final value_tungay =
        tach_tungay[2] + '-' + tach_tungay[1] + '-' + tach_tungay[0];
    final value_denngay =
        tach_dengay[2] + '-' + tach_dengay[1] + '-' + tach_dengay[0];
    setTrangthai() {
      switch (trangthai) {
        case 'Trạng thái':
          return '';
        case 'Đặt hàng':
          return 0;
        case 'Đã duyệt':
          return 1;
        case 'Đang giao':
          return 2;
        case 'Đã nhận':
          return 4;
      }
    }

    setThanhtoan() {
      switch (thanhtoan) {
        case 'Thanh toán':
          return '';
        case 'Đã thanh toán':
          return 0;
        case 'Chưa thanh toán':
          return 1;
      }
    }

    var params = {
      'mskh': msdv,
      'value_filter': valueSearch,
      'value_tungay': value_tungay,
      'value_denngay': value_denngay,
      'thanhtoan': setThanhtoan(),
      'trangthai': setTrangthai(),
    };
    final res = await HistoryApi.loadChitietLichSu(params);
    setState(() {
      listItemHistory = res;
    });
  }

  Future<void> loadTienTichLuy() async {
    final prefs = await SharedPreferences.getInstance();
    final msdv = prefs.getString('msdv') ?? '';
    var params = {"mskh": msdv};
    final res_tichluy = await ListCartApi.loadtientichluy(params);
    final res_chuathanhtoan = await HistoryApi.loadChuaThanhToan(params);
    final res_chitiettichluy = await HistoryApi.loadChitietTichLuy(params);
    print(res_chuathanhtoan[0]['chuathanhtoan']);
    setState(() {
      tientichluy = int.parse(res_tichluy[0]['sotien']);
      chuathanhtoan = (res_chuathanhtoan[0]['chuathanhtoan'] != null
          ? int.parse(res_chuathanhtoan[0]['chuathanhtoan'])
          : 0);
      listChitietTichluy = res_chitiettichluy;
    });
  }

  String verificationIDreceived = '';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử đơn hàng'),
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
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xffedf0f3),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Lịch sử đơn hàng | ',
                        style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      const Text(
                        'Chưa thanh toán: ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 0, 0),
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        current
                            .format(int.parse(chuathanhtoan.toString()))
                            .replaceAll(',', '.'),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 0, 0),
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(children: [
                      SizedBox(
                        height: 40,
                        child: TextField(
                          onChanged: (e) {
                            setState(() {
                              valueSearch = e;
                            });
                            loadChitietLichSu();
                          },
                          decoration: const InputDecoration(
                              hintText: "Tìm số hóa đơn",
                              labelStyle: TextStyle(color: Color(0xFF424242))),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 150,
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.width / 5,
                              child: Center(
                                  child: TextField(
                                controller: tungay,
                                decoration:
                                    const InputDecoration(labelText: "Từ ngày"),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                    setState(() {
                                      tungay.text = formattedDate;
                                    });
                                    loadChitietLichSu();
                                  } else {}
                                },
                              ))),
                          Container(
                              width: 150,
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.width / 5,
                              child: Center(
                                  child: TextField(
                                controller: dengay,
                                decoration: const InputDecoration(
                                    labelText: "Đến ngày"),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                    setState(() {
                                      dengay.text = formattedDate;
                                    });
                                    loadChitietLichSu();
                                  } else {}
                                },
                              ))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              DropdownButton(
                                value: thanhtoan,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: itemsthanhtoan.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    thanhtoan = newValue!;
                                  });
                                  loadChitietLichSu();
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              DropdownButton(
                                value: trangthai,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: itemstrangthai.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    trangthai = newValue!;
                                  });
                                  loadChitietLichSu();
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  for (final itemHistory in listItemHistory)
                    HitoryItem(itemHistory: itemHistory),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Quá trình tích lũy | ',
                        style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      const Text(
                        'Tiền tích lũy: ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 0, 0),
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        current
                            .format(int.parse(tientichluy.toString()))
                            .replaceAll(',', '.'),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 0, 0),
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(5)),
                      child: Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(),
                            3: FixedColumnWidth(105),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  width: 20,
                                  child: const Text(
                                    '#',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  child: const Text(
                                    'Ngày',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  child: const Text(
                                    'SỐ HĐ',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  child: const Text(
                                    'TIỀN TÍCH LŨY',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            for (int i = 0; i < listChitietTichluy.length; i++)
                              TableRow(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                children: <Widget>[
                                  Container(
                                    height: 40,
                                    width: 20,
                                    child: Text(
                                      (i + 1).toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    child: Text(
                                      listChitietTichluy[i]['ngay'],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    child: Text(
                                      listChitietTichluy[i]['sohd'],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          current
                                              .format(int.parse(
                                                  listChitietTichluy[i]
                                                      ['sotien']))
                                              .replaceAll(',', '.'),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
