import 'package:easy_shop/bd/message_database.dart';
import 'package:easy_shop/model/chatroom.dart';
import 'package:easy_shop/model/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/message.dart';

class ChatPage extends StatefulWidget {
  final int userid;
  final Item item;
  final Chatroom chatroom;

  const ChatPage({super.key, required this.chatroom, required this.userid, required this.item});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var msgController = TextEditingController();

  //final ScrollController _controller = ScrollController();

  // void _scrollDown() {
  //   _controller.animateTo(
  //     _controller.position.maxScrollExtent,
  //     duration: Duration(microseconds: 500),
  //     curve: Curves.fastOutSlowIn,
  //   );
  // }

  String temp = '';
  late List<Message> _messageList;

  Future getMessages() async {
    _messageList =
        await MessagesDatabase.instance.readAllMessages(widget.chatroom.id!);
    setState(() {});
  }

  Future createMessage(String data) async {
    Message message = Message(
        roomid: widget.chatroom.id!,
        senderid: widget.userid,
        time: DateTime.now(),
        data: data);
    await MessagesDatabase.instance.create(message);
  }

  @override
  void initState() {
    _messageList = [];
    getMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.item.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messageList.isNotEmpty
                ? Column(
              children: [
                Expanded(
                    child: ListView.builder(
                      //controller: _controller,
                            itemCount: _messageList.length,
                            //reverse: true,
                            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                alignment: _messageList[index].senderid ==
                                    widget.userid
                                    ? Alignment.centerRight
                                : Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Card(
                                      margin: const EdgeInsets.all(8),
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      color: _messageList[index].senderid ==
                                              widget.userid
                                          ? Colors.grey[300]
                                          : Theme.of(context).cardColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              _messageList[index].senderid ==
                                                      widget.userid
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _messageList[index].senderid ==
                                                      widget.userid
                                                  ? "你"
                                                  : _messageList[index].senderid == widget.item.ownerid ? "賣家" : "買家",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(_messageList[index].data),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ),
                Text(DateFormat('yyyy/MM/dd – kk:mm')
                    .format(_messageList.last.time))
              ],
            ): const Center(
              child: Text(
                "下方輸入訊息",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            // color: Palette.kToGrey[500],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 8.0, 16.0, 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      decoration: InputDecoration(
                          hintText: "傳送訊息...",
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                      onChanged: (text) {
                        temp = text;
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if(temp.isNotEmpty){
                          createMessage(temp);
                          getMessages();
                          //_scrollDown();
                          msgController.clear();
                          temp = '';
                        }
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
