import 'package:easy_shop/bd/buyer_database.dart';
import 'package:easy_shop/model/buyer.dart';
import 'package:easy_shop/toast.dart';
import 'package:flutter/material.dart';

import 'decoration/decorations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int buyerOrSeller = 1;
  String name = '';
  String phone = '';
  String email = '';
  String password = '';

  Future addBuyer(Buyer buyer) async {
    await BuyersDatabase.instance.create(buyer);
  }

  Future readBuyers() async {
    await BuyersDatabase.instance.readAllBuyers();
  }

  Future checkEmail(String email) async {
    final boo = await BuyersDatabase.instance.ifBuyerExistByEmail(email);
    if (boo) {
      warning("此電子信箱已註冊過！");
    } else {
      addBuyer(Buyer(
          name: name,
          phone: phone,
          email: email,
          password: password,
          review: 0.0,
          reviewCount: 0));
      warning("註冊成功");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('註冊帳號'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          ElevatedButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
              elevation: 0,
              shape: const CircleBorder(),
            ),
            onPressed: () {
              if (name != '' && phone != '' && email != '' && password != '') {
                checkEmail(email);
              } else {
                warning("請輸入所有欄位！");
              }
            },
            child: const Text(
              "完成",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(32.0),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '本名：',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                TextField(
                  decoration: filledInput,
                  onChanged: (text) {
                    name = text;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '電話：',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: filledInput,
                  onChanged: (text) {
                    phone = text;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '電子信箱：',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                TextField(
                  decoration: filledInput,
                  onChanged: (text) {
                    email = text;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '密碼：',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                TextField(
                  obscureText: true,
                  decoration: filledInput,
                  onChanged: (text) {
                    password = text;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
