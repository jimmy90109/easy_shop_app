import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:easy_shop/addItem.dart';
import 'package:easy_shop/bd/chatroom_database.dart';
import 'package:easy_shop/checkout.dart';
import 'package:easy_shop/detailPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'bd/cart_database.dart';
import 'bd/item_database.dart';
import 'bd/message_database.dart';
import 'bd/order_database.dart';
import 'chat.dart';
import 'main.dart';
import 'model/buyer.dart';
import 'model/cart.dart';
import 'model/chatroom.dart';
import 'model/item.dart';
import 'model/order.dart';

class ShoppingPage extends StatefulWidget {
  final Buyer user;

  const ShoppingPage({super.key, required this.user});
  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  int _selectedIndex = 0; //預設index

  late List<Item> _itemList;
  late List<Cart> _cartList;
  late List<Order> _orderList;

  int buyerOrSeller = 1;
  late List<Chatroom> _chatroomOfBuyer;
  late List<String> _lastMsgOfBuyer;
  late List<Chatroom> _chatroomOfSeller;
  late List<String> _lastMsgOfSeller;

  Future getItems() async {
    _itemList = await ItemsDatabase.instance.readAllItems();
    setState(() {});
  }

  Item searchItem(int id) {
    for (var item in _itemList) {
      if (item.id == id) {
        return item;
      }
    }
    throw Exception('ID $id not found');
  }

  Future getCart() async {
    _cartList = await CartsDatabase.instance.readCart(widget.user.id!);
    setState(() {});
  }

  Future deleteCart(int itemid) async {
    await CartsDatabase.instance.delete(widget.user.id!, itemid);
  }

  Future getOrders() async {
    _orderList = await OrdersDatabase.instance.readOrder(widget.user.id!);
    setState(() {});
  }

  Future completeOrder(Order order) async {
    final temp = order.copy(
      completed: true,
    );
    await OrdersDatabase.instance.update(temp);
  }

  Future getBuyerChatroom() async {
    _chatroomOfBuyer =
        await ChatroomsDatabase.instance.readBuyerChatroom(widget.user.id!);
    _lastMsgOfBuyer.clear();
    if (_chatroomOfBuyer.isNotEmpty) {
      for (var room in _chatroomOfBuyer) {
        _lastMsgOfBuyer
            .add(await MessagesDatabase.instance.readMessage(room.id!));
      }
    }
    setState(() {});
  }

  Future getSellerChatroom() async {
    _chatroomOfSeller =
        await ChatroomsDatabase.instance.readSellerChatroom(widget.user.id!);
    _lastMsgOfSeller.clear();
    if (_chatroomOfSeller.isNotEmpty) {
      for (var room in _chatroomOfSeller) {
        _lastMsgOfSeller
            .add(await MessagesDatabase.instance.readMessage(room.id!));
      }
    }
    setState(() {});
  }

  Future<int?> showSelectItemDialog() {
    int groupValue = 0;
    return showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            title: const Text("選擇一項商品去結帳"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: List<Widget>.generate(
                  _cartList.length,
                  (int index) {
                    var item = searchItem(_cartList[index].itemid);
                    return RadioListTile(
                      title: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("x${_cartList[index].itemNumber}"),
                      value: index,
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(() {
                          groupValue = value!;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                ),
                child: const Text("取消"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    //foregroundColor: Colors.blue,
                    ),
                child: const Text("確認"),
                onPressed: () {
                  Navigator.of(context).pop(groupValue);
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future<bool?> showConfirmDialog(String title) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text("確認"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    getBuyerChatroom();
    getSellerChatroom();

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _itemList = [];
    _cartList = [];
    // _cartDetails = [];
    _orderList = [];
    //_orderDetails = [];
    _chatroomOfBuyer = [];
    _lastMsgOfBuyer = [];
    _chatroomOfSeller = [];
    _lastMsgOfSeller = [];
    getItems();
    getCart();
    getOrders();
    getBuyerChatroom();
    getSellerChatroom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: user_info(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.perm_identity),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text("Easy Shop"),
        centerTitle: true,
        scrolledUnderElevation: 0,
        actions: [
          //item page
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddItemPage(
                              ownerID: widget.user.id!,
                            ))).then((value) => getItems());
              },
            )
          //cart page
          else if (_selectedIndex == 1 && _cartList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                int? checkout = await showSelectItemDialog();
                if (checkout != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                                buyer: widget.user,
                                item: searchItem(_cartList[checkout].itemid),
                                itemNumber: _cartList[checkout].itemNumber,
                              ))).then((value) {
                    getOrders();
                    getCart();
                    setState(() {
                      //move to order page
                      _selectedIndex = 2;
                    });
                  });
                }
              },
            )
        ],
      ),
      body: _selectedIndex == 0
          ? home()
          : _selectedIndex == 1
              ? shopping_cart()
              : _selectedIndex == 2
                  ? order()
                  : _selectedIndex == 3
                      ? chat()
                      : Container(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '商品',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '購物車',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: '訂單',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '聊天',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[800],
        unselectedItemColor: Colors.grey[500],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget user_info() {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.perm_identity,
                  size: 36,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.user.name,
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("ID："),
                Center(
                  child: Text(
                    widget.user.id.toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 32),
                const Text("Email："),
                Center(
                  child: Text(
                    widget.user.email,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                // const SizedBox(height: 32),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    child: const Text("登出"),
                    onPressed: () async {
                      var logout = await showConfirmDialog("登出");
                      if (logout == true) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage()),
                            (e) => false);
                      }
                    },
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget home() {
    return _itemList.isNotEmpty
        ? GridView.builder(
            itemCount: _itemList.length,
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //set how many cards in a row and card ratio
                crossAxisCount: 2,
                childAspectRatio: 10.0 / 14.0),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: const EdgeInsets.all(8),
                elevation: 10,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.0 / 1.0,

                        //for detailPage transition
                        child: Hero(
                            tag: index.toString(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                imageUrl: _itemList[index].imageURL,
                                fit: BoxFit.cover,

                                //Loading gif
                                placeholder: (context, url) => Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.grey.shade200,
                                    size: 50,
                                  ),
                                ),

                                //error icon
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            )),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _itemList[index].name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              softWrap: false,
                            ),
                            Text("\$ ${_itemList[index].price}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    getItems();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                                  user: widget.user,
                                  index: index.toString(),
                                  item: _itemList[index],
                                  pic: CachedNetworkImageProvider(
                                      _itemList[index].imageURL),
                                ))).then((value) {
                      getCart();
                    });
                  },
                ),
              );
            },
          )
        : const Center(
            child: Text(
              "右上角新增商品！",
              style: TextStyle(fontSize: 24),
            ),
          );
  }

  Widget shopping_cart() {
    return _cartList.isNotEmpty
        ? ListView.builder(
            itemCount: _cartList.length,
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            itemBuilder: (BuildContext context, int index) {
              var item = searchItem(_cartList[index].itemid);
              return SizedBox(
                height: 120,
                child: Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 10,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Hero(
                            tag: index.toString(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                width: 100,
                                imageUrl: item.imageURL,
                                fit: BoxFit.cover,

                                //Loading
                                placeholder: (context, url) => Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.grey.shade200,
                                    size: 50,
                                  ),
                                ),

                                //error
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            )),
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
                                      item.name,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      softWrap: false,
                                    ),
                                    Text("\$ ${item.price}"),
                                  ],
                                ),
                                Text("X ${_cartList[index].itemNumber}"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                    user: widget.user,
                                    index: index.toString(),
                                    item: item,
                                    pic: CachedNetworkImageProvider(
                                        item.imageURL),
                                  ))).then((value) {
                        getCart();
                        getOrders();
                      });
                    },
                    onLongPress: () async {
                      var delete = await showConfirmDialog("刪除這項項目");
                      if (delete == true) {
                        deleteCart(_cartList[index].itemid);
                        setState(() {
                          _cartList.removeAt(index);
                        });
                      }
                    },
                  ),
                ),
              );
            },
          )
        : const Center(
            child: Text(
              "去新增商品至購物車！",
              style: TextStyle(fontSize: 24),
            ),
          );
  }

  Future<bool?> showCompleteConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("確認已收到商品？"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text("取消"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text("確認"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Widget order() {
    return _orderList.isNotEmpty
        ? ListView.builder(
            itemCount: _orderList.length,
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            itemBuilder: (BuildContext context, int index) {
              var item = searchItem(_orderList[index].itemid);
              return Container(
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
                        Hero(
                            tag: index.toString(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                width: 100,
                                imageUrl: item.imageURL,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.grey.shade200,
                                    size: 50,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            )),
                        //),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 12.0, 16.0, 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      softWrap: false,
                                    ),
                                    Text("\$ ${item.price}"),
                                    Text("X ${_orderList[index].itemNumber}"),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(DateFormat('yyyy/MM/dd')
                                            .format(_orderList[index].time)),
                                        Text(DateFormat('kk:mm')
                                            .format(_orderList[index].time)),
                                      ],
                                    ),
                                    _orderList[index].completed
                                        ? const Text("已完成")
                                        : const Text(
                                            "未完成",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      if (!_orderList[index].completed) {
                        bool? done = await showConfirmDialog("確認已收到商品");
                        if (done != null){
                          //update orderdatabase
                          completeOrder(_orderList[index]);
                          getOrders();
                        }
                      }
                    },
                  ),
                ),
              );
            },
          )
        : const Center(
            child: Text(
              "去下訂單！",
              style: TextStyle(fontSize: 24),
            ),
          );
  }

  Widget chat() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(64.0, 8.0, 64.0, 8.0),
          child: CustomSlidingSegmentedControl<int>(
            initialValue: 1,
            isStretch: true,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            children: const {
              1: Text('找賣家'),
              2: Text('找買家'),
            },
            innerPadding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            thumbDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            onValueChanged: (v) {
              getBuyerChatroom();
              getSellerChatroom();
              setState(() {
                buyerOrSeller = v;
              });
              // print(buyerOrSeller);
            },
          ),
        ),
        Expanded(
            child: buyerOrSeller == 1
                ? _chatroomOfSeller.isNotEmpty
                    ? chatRoom(_chatroomOfSeller, _lastMsgOfSeller)
                    : const Center(
                        child: Text(
                          "無",
                          style: TextStyle(fontSize: 24),
                        ),
                      )
                : buyerOrSeller == 2
                    ? _chatroomOfBuyer.isNotEmpty
                        ? chatRoom(_chatroomOfBuyer, _lastMsgOfBuyer)
                        : const Center(
                            child: Text(
                              "無",
                              style: TextStyle(fontSize: 24),
                            ),
                          )
                    : Container()),
      ],
    );
  }

  Future<int> checkmsg(int roomid) async {
    int temp = await MessagesDatabase.instance.hasMessage(roomid);
    return temp;
  }

  Future<String> searchLastMessage(int roomid) async {
    String temp = await MessagesDatabase.instance.readMessage(roomid);
    return temp;
  }

  Widget chatRoom(List<Chatroom> list, List<String> lastmsg) {
    return ListView.separated(
      itemCount: list.length,
      padding: const EdgeInsets.all(16.0),
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        var item = searchItem(list[index].itemid);

        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: CachedNetworkImage(
              width: 60,
              imageUrl: item.imageURL,
              fit: BoxFit.cover,
              placeholder: (context, url) => Padding(
                padding: const EdgeInsets.all(32.0),
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.grey.shade200,
                  size: 5,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          title: Text(
            item.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            softWrap: false,
          ),
          subtitle: Text(
            lastmsg[index],
          ),
          // trailing: Text(hasmsg == 1
          //     ? DateFormat('yyyy/MM/dd – kk:mm').format(lastTime)
          //     : " "),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => ChatPage(
                        userid: widget.user.id!,
                        item: item,
                        chatroom: list[index]))).then((value) {
              getBuyerChatroom();
              getSellerChatroom();
            });
          },
        );
      },
    );
  }
}
