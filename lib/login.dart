import 'package:easy_shop/shoppingPage.dart';
import 'package:easy_shop/toast.dart';
import 'package:flutter/material.dart';
import 'bd/buyer_database.dart';
import 'decoration/decorations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';

  Future checkEmail(String email) async {
    final boo = await BuyersDatabase.instance.ifBuyerExistByEmail(email);
    if (boo) {
      final user = await BuyersDatabase.instance.readBuyerByEmail(email);
      if (user.password == password) {
        warning("登入成功！");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => ShoppingPage(user: user)),
            (e) => false);
      } else {
        warning("密碼錯誤！");
      }
    } else {
      warning("此電子信箱還沒註冊過！");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登入'),
        centerTitle: true,
        elevation: 0,
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
            const SizedBox(
              height: 30,
            ),
            FilledButton(
              child: const Text("登入"),
              onPressed: () {
                if (email != '' && password != '') {
                  checkEmail(email);
                } else {
                  warning("請輸入所有欄位！");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
