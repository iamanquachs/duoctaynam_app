import 'package:app_dtn/screens/home/home.dart';
import 'package:app_dtn/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModalLogin extends StatefulWidget {
  const ModalLogin({super.key});
  @override
  State<ModalLogin> createState() => _ModalLoginState();
}

class _ModalLoginState extends State<ModalLogin> {
  String sodienthoai = "";
  final loadGetx = Get.put(CountCart());

  @override
  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();

    var params = {"sdt": sodienthoai};
    final egpp = await Login.login(params);

    //add local bằng egpp
    if (egpp.length > 0) {
      await prefs.setString('msdn', sodienthoai);
      await prefs.setString('dienthoai', sodienthoai);
      await prefs.setString('tendv', egpp[0].tendv);
      await prefs.setString('tendaidien', egpp[0].tendaidien);
      await prefs.setString('diachi', egpp[0].diachi);
      await prefs.setString('msxa', egpp[0].msxa);
      await prefs.setString('msdv', egpp[0].msdv);
    }
    //add local bằng duoctaynam
    else {
      var params = {"msdn": sodienthoai};
      final dtn = await Login.KtraDTN(params);

      if (dtn.length > 0) {
        await prefs.setString('msdn', sodienthoai);
        await prefs.setString('dienthoai', sodienthoai);
        await prefs.setString('tendv', dtn[0].tenkhachhang);
        await prefs.setString('diachi', dtn[0].diachi);
        await prefs.setString('msxa', dtn[0].msxa);
        await prefs.setString('msdv', dtn[0].msdv);
      } else {
        await prefs.setString('msdn', sodienthoai);
        await prefs.setString('dienthoai', sodienthoai);
        await prefs.setString('tendv', sodienthoai);
        await prefs.setString('msdv', sodienthoai);
      }
    }
    await loadGetx.setMSDN();
    Navigator.of(context).pop();
    loadGetx.handleListCart();
    loadGetx.loadHotItems();
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Số điện thoại đặt hàng',
        style: TextStyle(color: Color.fromARGB(242, 40, 169, 0)),
      ),
      content: Container(
        width: double.infinity,
        height: 55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Container(
              width: 220,
              height: 40,
              child: TextField(
                  onChanged: (e) {
                    setState(() {
                      sodienthoai = e;
                    });
                  },
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.green)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      hintText: 'Số điện thoại')),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
                backgroundColor: MaterialStateProperty.all(Colors.green),
                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 16, color: Colors.white))),
            onPressed: () {
              login();
            },
            child: const Text('Đồng ý')),
        ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )),
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 224, 224, 224)),
                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
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
  }
}
