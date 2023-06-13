import 'package:easy_shop/bd/item_database.dart';
import 'package:easy_shop/toast.dart';
import 'package:flutter/material.dart';
import 'model/item.dart';

class EditItemPage extends StatefulWidget {
  final int ownerID;
  final Item item;

  const EditItemPage({super.key, required this.ownerID, required this.item});
  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  String name = '', detail = '', imageURL = '';
  int price = 0, inventory = 0;

  Future updateItem(Item item) async {
    await ItemsDatabase.instance.update(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('修改商品'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          ElevatedButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
              elevation: 0,
              shape: const CircleBorder(
                  side: BorderSide(color: Colors.transparent)),
            ),
            onPressed: () {
              if (name == '') name = widget.item.name;
              if (detail == '') detail = widget.item.description;
              if (imageURL == '') imageURL = widget.item.imageURL;
              if (price == 0) price = widget.item.price;
              if (inventory == 0) inventory = widget.item.inventory;

              updateItem(Item(
                  id: widget.item.id,
                  ownerid: widget.ownerID,
                  name: name,
                  description: detail,
                  price: price,
                  imageURL: imageURL,
                  inventory: inventory));

              warning("已更新");

              Navigator.pop(context);
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
                      hintText: widget.item.name,
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
                ),
                Text(
                  '商品圖網址：',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: widget.item.imageURL,
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
                      hintText: widget.item.description,
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
                      hintText: widget.item.price.toString(),
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
                      hintText: widget.item.inventory.toString(),
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
