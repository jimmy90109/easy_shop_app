import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_shop/bd/cart_database.dart';
import 'package:easy_shop/bd/chatroom_database.dart';
import 'package:easy_shop/chat.dart';
import 'package:easy_shop/model/item.dart';
import 'package:easy_shop/toast.dart';
import 'package:flutter/material.dart';

import 'model/buyer.dart';
import 'model/cart.dart';
import 'model/chatroom.dart';

class DetailPage extends StatelessWidget {
  final Buyer user;
  final String index;
  final Item item;
  final CachedNetworkImageProvider pic;

  const DetailPage(
      {super.key,
      required this.index,
      required this.item,
      required this.pic,
      required this.user});

  Future createRoom(Chatroom chatroom) async {
    await ChatroomsDatabase.instance.create(chatroom);
    //warning("已新增至購物車！");
  }

  Future addToCart() async {
    await CartsDatabase.instance.update(Cart(
      userid: user.id!,
      itemid: item.id!,
      itemNumber: 1,
    ));
    warning("已新增至購物車！");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
                tag: index,
                child: Image(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                  image: CachedNetworkImageProvider(item.imageURL),
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  "\$ ${item.price}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  "庫存：${item.inventory}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ]),
                    ),
                    Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.grey.shade200,
                        ),
                        child: Text(item.description))
                  ],
                ),
              ),
            ),
            // if(user.id == item.ownerid)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton(
                      onPressed: user.id == item.ownerid
                          ? null
                          : () {
                        final chatroom = Chatroom(
                          buyerid: user.id!,
                          itemid: item.id!,
                        );
                              createRoom(chatroom);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) => ChatPage(userid: user.id!, item: item, chatroom: chatroom)));
                            },
                      child: const Text("聯絡賣家")),
                  FilledButton(
                      onPressed:
                          user.id == item.ownerid ? null : () => addToCart(),
                      child: const Text("加入購物車")),
                ],
              ),
            ),
          ]),
    );
  }
}
