final String tableChatrooms = 'chatrooms';

class ChatroomFields {
  static final List<String> values = [id, buyerid, itemid];

  static final String id = '_id';
  static final String buyerid = 'buyerid';
  static final String itemid = 'itemid';
}

class Chatroom {
  final int? id;
  final int buyerid;
  final int itemid;

  const Chatroom({this.id, required this.buyerid, required this.itemid});

  Chatroom copy({int? id, int? buyerid, int? sellerid}) => Chatroom(
        id: id ?? this.id,
        buyerid: buyerid ?? this.buyerid,
    itemid: sellerid ?? this.itemid,
      );

  static Chatroom fromJson(Map<String, Object?> json) => Chatroom(
      id: json[ChatroomFields.id] as int?,
      buyerid: json[ChatroomFields.buyerid] as int,
      itemid: json[ChatroomFields.itemid] as int);

  Map<String, Object?> toJson() => {
        ChatroomFields.id: id,
        ChatroomFields.buyerid: buyerid,
        ChatroomFields.itemid: itemid,
      };
}
