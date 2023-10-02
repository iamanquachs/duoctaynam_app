import 'package:app_dtn/services/history_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HitoryItem extends StatefulWidget {
  const HitoryItem({super.key, required this.itemHistory});

  final itemHistory;
  @override
  State<HitoryItem> createState() => _HitoryItemState();
}

class _HitoryItemState extends State<HitoryItem> {
  var historyLine = [];
  var chitietThuchi = [];
  final current = NumberFormat("#,##0", "en_US");
  var qr_thanhtoan = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      historyLine = widget.itemHistory['line'];
    });
    CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  }

  handleDaThanhToan() async {
    final soct = widget.itemHistory['soct'];
    var params = {"soct": soct};
    await HistoryApi.handleDaThanhToan(params);
    Navigator.of(context).pop();
  }

  handleLoadQR(e) async {
    var params = {"soct": e};
    final res = await HistoryApi.loadQR(params);
    setState(() {
      qr_thanhtoan = res.length > 0 ? res[0]['qrthanhtoan'] : '';
    });
  }

  handleLoadChiTietThanhToan() async {
    final soct = widget.itemHistory['soct'];
    var paramsSoct = {"soct": soct};
    final soctThuchi = await HistoryApi.load_sct_thuchi(paramsSoct);
    var params = {"soct": soctThuchi[0]['soct']};
    final chitiet = await HistoryApi.listChitietThuChiHistory(params);
    setState(() {
      chitietThuchi = chitiet;
    });
  }

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: const BoxDecoration(color: Color(0xffe4f7e4)),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Ngày ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            widget.itemHistory['ngay'],
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      SizedBox(
                        child: Column(
                          children: [
                            if (widget.itemHistory['dathanhtoan'] == '1')
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  handleLoadChiTietThanhToan();
                                  _showFormDaThanhToan();
                                },
                                child: const Text(
                                  'Đã thanh toán',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                              ),
                            if (widget.itemHistory['dathanhtoan'] != '1')
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  handleLoadQR(widget.itemHistory['soct']);
                                  _showFormThanhToan();
                                },
                                child: const Text(
                                  'Thanh toán',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Số hóa đơn',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            widget.itemHistory['sohd'],
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Tổng tiền ',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            current
                                .format(int.parse(widget
                                    .itemHistory['tongcongvat']
                                    .toString()))
                                .replaceAll(',', '.'),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 0, 0),
                                fontSize: 18),
                          )
                        ],
                      )
                    ]),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
            ),
            decoration: const BoxDecoration(color: Color(0xfffffffff)),
            child: Column(
              children: [
                Table(
                    columnWidths: const <int, TableColumnWidth>{
                      0: IntrinsicColumnWidth(),
                      1: FixedColumnWidth(35),
                      2: FixedColumnWidth(45),
                      3: FlexColumnWidth(),
                      4: FixedColumnWidth(70),
                      5: FixedColumnWidth(60),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      TableRow(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.black38))),
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 5),
                            width: 70,
                            height: 40,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'TÊN SẢN PHẨM',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 5),
                            width: 50,
                            height: 40,
                            child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ĐVT',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                  )
                                ]),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 5),
                            width: 50,
                            height: 40,
                            child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'SỐ LƯỢNG',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                    textAlign: TextAlign.end,
                                  )
                                ]),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 5),
                            width: 50,
                            height: 40,
                            child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ĐƠN GIÁ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                    textAlign: TextAlign.end,
                                  )
                                ]),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 5),
                            height: 40,
                            child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'THÀNH TIỀN',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                    textAlign: TextAlign.end,
                                  )
                                ]),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 5),
                            width: 70,
                            height: 40,
                            child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'TIỀN TÍCH LŨY',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                    textAlign: TextAlign.end,
                                  )
                                ]),
                          ),
                        ],
                      ),
                      for (int i = 0; i < historyLine.length; i++)
                        TableRow(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.black38))),
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 5),
                              width: 90,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text(historyLine[0]['tenhh'])]),
                            ),
                            Container(
                                padding: EdgeInsets.only(right: 5),
                                width: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(historyLine[i]['dvt']),
                                  ],
                                )),
                            Container(
                              padding: EdgeInsets.only(right: 5),
                              width: 50,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [Text(historyLine[i]['soluong'])]),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 5),
                              width: 50,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(current
                                        .format(int.parse(historyLine[i]
                                                ['giaban']
                                            .toString()))
                                        .replaceAll(',', '.'))
                                  ]),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 5),
                              width: 50,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(current
                                        .format(int.parse(historyLine[i]
                                                ['thanhtienvat']
                                            .toString()))
                                        .replaceAll(',', '.'))
                                  ]),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 5),
                              width: 70,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(current
                                        .format(double.parse(historyLine[i]
                                                ['tientichluy']
                                            .toString()))
                                        .replaceAll(',', '.'))
                                  ]),
                            ),
                          ],
                        ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.itemHistory['ngay'] != '00:00 00/00/0000')
                      Container(
                        width: 83,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 2, color: Color(0xffc3f4a6)))),
                        child: Column(children: [
                          Text('Đặt hàng'),
                          Text(
                            (widget.itemHistory['ngay']),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                      ),
                    if (widget.itemHistory['time_xacnhan'] !=
                        '00:00 00/00/0000')
                      Container(
                        width: 83,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 2, color: Color(0xff8dc4f5)))),
                        child: Column(children: [
                          const Text('Đã duyệt'),
                          Text(
                            (widget.itemHistory['time_xacnhan']),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                      ),
                    if (widget.itemHistory['time_giao'] != '00:00 00/00/0000')
                      Container(
                        width: 83,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 2, color: Color(0xfff5d06b)))),
                        child: Column(children: [
                          const Text('Đang giao'),
                          Text(
                            (widget.itemHistory['time_giao']),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                      ),
                    if (widget.itemHistory['time_nhan'] != '00:00 00/00/0000')
                      Container(
                        width: 83,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 2, color: Color(0xfff8924f)))),
                        child: Column(children: [
                          const Text('Đã nhận'),
                          Text(
                            (widget.itemHistory['time_nhan']),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                      )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showFormThanhToan() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Thông tin thanh toán',
            style: TextStyle(color: Color.fromARGB(242, 40, 169, 0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vui lòng sử dụng Sacombank Pay để quét mã thanh toán dưới đây.',
                      textAlign: TextAlign.center,
                    ),
                    Stack(
                      children: [
                        if (qr_thanhtoan != '')
                          Container(
                            width: double.infinity,
                            child: Image.asset('images/icons/nen_qr.png'),
                          ),
                        Positioned(
                          top: 37,
                          right: 38,
                          child: Column(
                            children: [
                              if (qr_thanhtoan != '')
                                Container(
                                  width: 180,
                                  height: 180,
                                  child: Image(
                                    image: CachedNetworkImageProvider(
                                        'https://erp.duoctaynam.vn/upload/qr_thanhtoan/${qr_thanhtoan}'),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (qr_thanhtoan == '')
                          Container(
                            child: const Text(
                              'Chờ cập nhật',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 0, 0),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                      ],
                    )
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
                  handleDaThanhToan();
                },
                child: const Text(
                  'Đã thanh toán',
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

  Future<void> _showFormDaThanhToan() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Thông tin thanh toán',
            style: TextStyle(color: Color.fromARGB(242, 40, 169, 0)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < chitietThuchi.length; i++)
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text('Ngày'),
                                ),
                                Text(chitietThuchi[i]['ngay'])
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text('Số tiền'),
                                ),
                                Text(
                                  current
                                      .format(int.parse(chitietThuchi[i]
                                              ['sotien']
                                          .toString()))
                                      .replaceAll(',', '.'),
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 0, 0)),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text('Hình thức'),
                                ),
                                Text(chitietThuchi[i]['nganquy'])
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text('Nv thu'),
                                ),
                                Text(chitietThuchi[i]['tennhanvien'])
                              ],
                            )
                          ],
                        ),
                      )
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
