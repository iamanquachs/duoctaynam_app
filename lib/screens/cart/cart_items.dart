import 'package:app_dtn/model/cart_model.dart';
import 'package:app_dtn/screens/cart/cart.dart';
import 'package:app_dtn/screens/home/home.dart';
import 'package:app_dtn/services/cart_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CartItem extends StatefulWidget {
  const CartItem({super.key, required this.itemCart, required this.checked});
  final ListCart itemCart;
  final checked;
  @override
  State<CartItem> createState() => _CartItemState();
}

class CartTinhTong extends GetxController {
  final CartList other = Get.find();

  RxInt tongcong = 0.obs;

  CheckCart(e, check, changesl) {
    if (changesl == '') {
      if (check == true) {
        (other.tongtien + int.parse(e.thanhtienvat));
        other.listOther.add(e);
      } else {
        (other.tongtien - int.parse(e.thanhtienvat));
        other.listOther.remove(e);
      }
    } else {}
  }
}

class _CartItemState extends State<CartItem> {
  var chietkhau = 0;
  final current = new NumberFormat("#,##0", "en_US");
  final cartList = Get.put(CartList());
  final checkCart = Get.put(CartTinhTong());
  final CartList other = Get.find();
  final CartTinhTong otherCheck = Get.find();

  final soluongCart = Get.put(CountCart());
  var soluong = 0;
  var checkItem = true;
  @override
  void initState() {
    super.initState();
  }

  handleCheckCart(e) {
    checkCart.CheckCart(widget.itemCart, e, '');
    setState(() {
      checkItem = e;
    });
  }

  void deleteItemCart() async {
    var rowid = widget.itemCart.rowid;
    final prefs = await SharedPreferences.getInstance();
    final msdn = prefs.getString('msdn') ?? '';
    var params = {'msdn': msdn, 'rowid': rowid};
    await ListCartApi.deleteItemCart(params);
    Navigator.of(context).pop();
    cartList.handleListCart(checkItem);
    soluongCart.handleListCart();
  }

  add_hanghoa_km() async {
    final prefs = await SharedPreferences.getInstance();
    final msdn = prefs.getString('msdn') ?? '';
    var params = {'msdn': msdn};
    await ListCartApi.add_hanghoa_km(params);
    soluongCart.handleListCart();
  }

  soluong_tang() async {
    final prefs = await SharedPreferences.getInstance();
    soluong = int.parse(widget.itemCart.soluong) + 1;
    final msdn = prefs.getString('msdn') ?? '';

    var params = {
      'msdn': msdn,
      'mshh': widget.itemCart.mshh,
      'soluong': soluong,
      'ptgiam': widget.itemCart.ptgiam
    };
    await ListCartApi.updateGiohang(params);
    add_hanghoa_km();
    checkCart.CheckCart(widget.itemCart, checkItem, 'changesl');
    cartList.handleListCart(checkItem);
  }

  soluong_giam() async {
    final prefs = await SharedPreferences.getInstance();
    if (int.parse(widget.itemCart.soluong) > 1) {
      soluong = int.parse(widget.itemCart.soluong) - 1;
      final msdn = prefs.getString('msdn') ?? '';

      var params = {
        'msdn': msdn,
        'mshh': widget.itemCart.mshh,
        'soluong': soluong,
        'ptgiam': widget.itemCart.ptgiam
      };
      await ListCartApi.updateGiohang(params);
      add_hanghoa_km();
      checkCart.CheckCart(widget.itemCart, checkItem, 'changesl');
      cartList.handleListCart(checkItem);
    }
  }

  bool isChecked = true;
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color.fromARGB(189, 103, 100, 100), width: 1))),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                  child: Checkbox(
                    checkColor: Colors.white,
                    value: checkItem,
                    onChanged: (bool? value) {
                      handleCheckCart(value);
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 90,
                      width: 100,
                      decoration: BoxDecoration(
                          color: const Color(0xff475269),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://erp.duoctaynam.vn/upload/sanpham/${widget.itemCart.path_image}',
                          height: 110,
                          width: 110,
                          fit: BoxFit.contain,
                        ))
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 183,
                          child: Text(widget.itemCart.tenhh,
                              style: const TextStyle(
                                color: Color(0xfff4a8000),
                              )),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 80,
                              child: const Text('Giá gốc'),
                            ),
                            Text(current
                                .format(int.parse(widget.itemCart.giagoc))
                                .replaceAll(',', '.'))
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 80,
                              child: const Text('Số lượng'),
                            ),
                            Container(
                              width: 90,
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 25,
                                      child: IconButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () {
                                            soluong_giam();
                                          },
                                          icon: const Icon(Icons.remove)),
                                    ),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: TextFormField(
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  (widget.itemCart.soluong),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10))),
                                    ),
                                    SizedBox(
                                      width: 25,
                                      child: IconButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () {
                                            soluong_tang();
                                          },
                                          icon: const Icon(Icons.add)),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 80,
                              child: const Text('Thành tiền'),
                            ),
                            Text(current
                                .format(int.parse(widget.itemCart.thanhtien))
                                .replaceAll(',', '.'))
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 80, child: const Text('Chiết khấu')),
                            Text(
                                '${current.format(int.parse(widget.itemCart.giagoc) * int.parse(widget.itemCart.soluong) - int.parse(widget.itemCart.thanhtien)).replaceAll(',', '.')}(${widget.itemCart.ptgiam}%)')
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 80, child: const Text('Thanh toán')),
                            Text(
                                current
                                    .format(
                                        int.parse(widget.itemCart.thanhtienvat))
                                    .replaceAll(',', '.'),
                                style: const TextStyle(
                                  color: Color(0xffff0018),
                                ))
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Positioned(
              right: -10,
              top: -14,
              child: IconButton(
                onPressed: () {
                  _ModaldeleteCart();
                },
                icon: const Icon(
                  Icons.highlight_remove,
                  color: Color(0xE0E70017),
                ),
              )),
        ],
      ),
    );
  }

  //!Modal delete cart

  Future<void> _ModaldeleteCart() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Đồng ý xóa ' + widget.itemCart.tenhh,
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 203, 14, 0)),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15)),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 16, color: Colors.white))),
                onPressed: () {
                  deleteItemCart();
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
