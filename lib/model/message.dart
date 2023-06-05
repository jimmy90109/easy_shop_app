final String tableMessages = 'messages';

class MessageFields {
  static final List<String> values = [id, roomid, senderid, time, data];

  static final String id = '_id';
  static final String roomid = 'roomid';
  static final String senderid = 'senderid';
  static final String time = 'time';
  static final String data = 'data';
}

class Message {
  final int? id;
  final int roomid;
  final int senderid;
  final DateTime time;
  final String data;

  const Message(
      {this.id,
      required this.roomid,
      required this.senderid,
      required this.time,
      required this.data});

  Message copy(
          {int? id,
          int? roomid,
          int? senderid,
          DateTime? time,
          String? data}) =>
      Message(
          id: id ?? this.id,
          roomid: roomid ?? this.roomid,
          senderid: senderid ?? this.senderid,
          time: time ?? this.time,
          data: data ?? this.data);

  static Message fromJson(Map<String, Object?> json) => Message(
      id: json[MessageFields.id] as int?,
      roomid: json[MessageFields.roomid] as int,
      senderid: json[MessageFields.senderid] as int,
      time: DateTime.parse(json[MessageFields.time] as String),
      data: json[MessageFields.data] as String);

  Map<String, Object?> toJson() => {
        MessageFields.id: id,
        MessageFields.roomid: roomid,
        MessageFields.senderid: senderid,
        MessageFields.time: time.toIso8601String(),
        MessageFields.data: data
      };
}
