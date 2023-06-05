const String tableOrders = 'orders';

class OrderFields {
  static final List<String> values = [
    id, buyerid, sellerid, time, address, itemid, itemNumber, completed
  ];

  static final String id = '_id';
  static final String buyerid = 'buyerid';
  static final String sellerid = 'sellerid';
  static final String time = 'time';
  static final String address = 'address';
  static final String itemid = 'itemid';
  static final String itemNumber = 'itemNumber';
  static final String completed = 'completed';
}

class Order {
  final int? id;
  final int buyerid;
  final int sellerid;
  final DateTime time;
  final String address;
  final int itemid;
  final int itemNumber;
  final bool completed;

  const Order({
    this.id,
    required this.buyerid,
    required this.sellerid,
    required this.time,
    required this.address,
    required this.itemid,
    required this.itemNumber,
    required this.completed
  });

  Order copy({
    int? id,
    int? buyerid,
    int? sellerid,
    DateTime? time,
    String? address,
    int? itemid,
    int? itemNumber,
    bool? completed
  }) =>
      Order(
        id: id ?? this.id,
        buyerid: buyerid ?? this.buyerid,
        sellerid: sellerid ?? this.sellerid,
        time: time ?? this.time,
        address: address ?? this.address,
        itemid: itemid ?? this.itemid,
        itemNumber: itemNumber ?? this.itemNumber,
        completed: completed ?? this.completed
      );

  static Order fromJson(Map<String, Object?> json) => Order(
    id: json[OrderFields.id] as int,
    buyerid: json[OrderFields.buyerid] as int,
    sellerid: json[OrderFields.sellerid] as int,
    time: DateTime.parse(json[OrderFields.time] as String) ,
    address: json[OrderFields.address] as String,
    itemid: json[OrderFields.itemid] as int,
    itemNumber: json[OrderFields.itemNumber] as int,
    completed: json[OrderFields.completed] == 1
  );

  Map<String, Object?> toJson() => {
    OrderFields.id: id,
    OrderFields.buyerid: buyerid,
    OrderFields.sellerid: sellerid,
    OrderFields.time: time.toIso8601String(),
    OrderFields.address: address,
    OrderFields.itemid: itemid,
    OrderFields.itemNumber: itemNumber,
    OrderFields.completed: completed ? 1 :0
  };
}