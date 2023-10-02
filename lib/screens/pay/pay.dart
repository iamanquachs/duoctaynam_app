import 'package:app_dtn/screens/home/home.dart';
import 'package:app_dtn/services/cart_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Pay extends StatefulWidget {
  const Pay({super.key, required this.soct});
  final soct;
  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  var thanhtien = 0;
  final loadGetx = Get.put(CountCart());

  final current = new NumberFormat("#,##0", "en_US");

  @override
  void initState() {
    super.initState();
    loadThanhTenDonHang();
  }

  loadThanhTenDonHang() async {
    var params = {'soct': widget.soct};
    final res = await ListCartApi.getThanhtienDonhang(params);
    setState(() {
      thanhtien = int.parse(res[0]['tongcongvat']);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: Image.asset('images/icons/success.png'),
                ),
                const Text(
                  'Đặt hàng thành công.',
                  style: TextStyle(color: Color(0xff008018), fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Tổng cộng: ${current.format(thanhtien).replaceAll(',', '.')} đ',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 0, 0), fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Quý khách vui lòng thanh toán, để chúng tôi giao hàng nhanh nhất',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(0, 133, 4, 1),
                      ),
                      onPressed: () {
                        loadThanhTenDonHang();
                      },
                      child: const Text(
                        'Thanh toán ngay (VNPAY)',
                        style: TextStyle(fontSize: 18),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Cần hỗ trợ thêm, quý khách vui lòng liên hệ',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Hotline/Zalo: 0931 86 79 65',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Trân trọng cảm ơn và xin chào',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                    child: const Text(
                      'Tiếp tục mua hàng',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff0000000),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500),
                    ))
              ],
            )));
  }
}
