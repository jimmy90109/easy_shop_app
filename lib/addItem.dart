import 'package:easy_shop/bd/item_database.dart';
import 'package:easy_shop/toast.dart';
import 'package:flutter/material.dart';
import 'color/palette.dart';
import 'model/item.dart';

class AddItemPage extends StatefulWidget {
  final int ownerID;

  const AddItemPage({super.key, required this.ownerID});
  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
 //id, ownerid, name, description, price, imageURL, inventory
  String name='', detail='', imageURL='';
  int price=0, inventory=0;

  Future createItem (Item item) async {
    await ItemsDatabase.instance.create(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增商品'),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: [
          ElevatedButton(
            style: TextButton.styleFrom(
              //backgroundColor: Palette.kToGrey,
              padding: const EdgeInsets.all(0),
              elevation: 0,
              shape: const CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
            onPressed: () {
              if (name!='' && detail!='' && imageURL!='' && price!=0 && inventory!=0){
                createItem(Item(
                    ownerid: widget.ownerID,
                    name: name,
                    description: detail,
                    price: price,
                    imageURL: imageURL,
                    inventory: inventory
                ));
                Navigator.pop(context);
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
          //shrinkWrap: true,
          padding: const EdgeInsets.all(32.0),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '商品名稱：',
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
                    name = text;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),Text(
                  '商品圖網址：',
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
                    imageURL = text;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '商品細節：',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                TextField(
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (text) {
                    detail = text;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '商品價格：',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (text) {
                    price = int.parse(text);
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '商品庫存：',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (text) {
                    inventory = int.parse(text);
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
