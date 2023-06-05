import 'package:easy_shop/shoppingPage.dart';
import 'package:easy_shop/toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'bd/buyer_database.dart';

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
    //print(boo);
    if (boo) {
      //warning("此電子信箱已註冊過！");
      final user = await BuyersDatabase.instance.readBuyerByEmail(email);
      if (user.password == password) {
        //print all buyers
        print(await BuyersDatabase.instance.readAllBuyers());
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => ShoppingPage(user: user)),
                (e) => false);
        //Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingPage()));
        warning("登入成功！");
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
        elevation: 0,
        centerTitle: true,
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
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )),
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
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )),
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
                onPressed: () {
                  if (email != '' && password != '') {
                    checkEmail(email);
                  } else {
                    warning("請輸入所有欄位！");
                  }
                },
                child: const Text("登入"))
          ],
        ),
      ),

    );
  }
}
