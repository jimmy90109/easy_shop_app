import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_shop/model/buyer.dart';
import 'package:easy_shop/toast.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'bd/cart_database.dart';
import 'bd/order_database.dart';
import 'model/item.dart';
import 'model/order.dart';

class CheckoutPage extends StatefulWidget {
  final Buyer buyer;
  final Item item;
  final int itemNumber;

  const CheckoutPage({
    super.key,
    required this.buyer,
    required this.item,
    required this.itemNumber,
  });
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String address = '';

  Future createOrder(Order order) async {
    await OrdersDatabase.instance.create(order);
  }

  Future deleteCart() async {
    await CartsDatabase.instance.delete(widget.buyer.id!, widget.item.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('下單'),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(32.0),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 120,
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // AspectRatio(
                          //   aspectRatio: 18.0 / 18.0,
                          //   child:
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: CachedNetworkImage(
                              width: 100,
                              imageUrl: widget.item.imageURL,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.grey.shade200,
                                  size: 50,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          //),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 12.0, 16.0, 12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        widget.item.name,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        softWrap: false,
                                      ),
                                      //const SizedBox(height: 8.0),
                                      Text("\$ ${widget.item.price}"),
                                    ],
                                  ),
                                  //const SizedBox(height: 8.0),
                                  Text("X ${widget.itemNumber}"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      '訂單總金額：' +
                          (widget.item.price * widget.itemNumber).toString() +
                          " 元",
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '取貨人：',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: widget.buyer.name,
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (text) {
                    address = text;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '取貨人手機：',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      labelText: widget.buyer.phone,
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )),
                  onChanged: (text) {
                    address = text;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '宅配地址：',
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
                    address = text;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                FilledButton(
                    onPressed: () {
                      if (address != '') {
                        createOrder(Order(
                            buyerid: widget.buyer.id!,
                            sellerid: widget.item.ownerid,
                            time: DateTime.now(),
                            address: address,
                            itemid: widget.item.id!,
                            itemNumber: widget.itemNumber,
                            completed: false));
                        deleteCart();
                        Navigator.pop(context);
                      } else {
                        warning("請輸入宅配地址！");
                      }
                    },
                    child: const Text("送出"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
