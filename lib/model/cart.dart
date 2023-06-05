const String tableCarts = 'carts';

class CartFields {
  static final List<String> values = [
    userid, itemid, itemNumber
  ];

  static const String userid = 'userid';
  static const String itemid = 'itemid';
  static const String itemNumber = 'itemNumber';
}

class Cart {
  final int userid;
  final int itemid;
  final int itemNumber;

  const Cart({
    required this.userid,
    required this.itemid,
    required this.itemNumber
  });

  Cart copy({
    int? userid,
    int? itemid,
    int? itemNumber
  }) =>
      Cart(
        userid: userid ?? this.userid,
        itemid: itemid ?? this.itemid,
        itemNumber: itemNumber ?? this.itemNumber
      );

  static Cart fromJson(Map<String, Object?> json) => Cart(
    userid: json[CartFields.userid] as int,
    itemid: json[CartFields.itemid] as int,
    itemNumber: json[CartFields.itemNumber] as int
  );

  Map<String, Object?> toJson() => {
    CartFields.userid: userid,
    CartFields.itemid: itemid,
    CartFields.itemNumber: itemNumber
  };
}