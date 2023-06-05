const String tableItems = 'items';

class ItemFields {
  static final List<String> values = [
    id, ownerid, name, description, price, imageURL, inventory
  ];

  static const String id = '_id';
  static const String ownerid = 'ownerid';
  static const String name = 'name';
  static const String description = 'description';
  static const String price = 'price';
  static const String imageURL = 'imageURL';
  static const String inventory = 'inventory';
}

class Item {
  final int? id;
  final int ownerid;
  final String name;
  final String description;
  final int price;
  final String imageURL;
  final int inventory;

  const Item({
    this.id,
    required this.ownerid,
    required this.name,
    required this.description,
    required this.price,
    required this.imageURL,
    required this.inventory,
  });

  Item copy({
    int? id,
    int? ownerid,
    String? name,
    String? description,
    int? price,
    String? imageURL,
    int? inventory,
  }) =>
      Item(
        id: id ?? this.id,
        ownerid: id ?? this.ownerid,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        imageURL: imageURL ?? this.imageURL,
        inventory: inventory ?? this.inventory,
      );

  static Item fromJson(Map<String, Object?> json) => Item(
    id: json[ItemFields.id] as int?,
    ownerid: json[ItemFields.ownerid] as int,
    name: json[ItemFields.name] as String,
    description: json[ItemFields.description] as String,
    price: json[ItemFields.price] as int,
    imageURL: json[ItemFields.imageURL] as String,
    inventory: json[ItemFields.inventory] as int,
  );

  Map<String, Object?> toJson() => {
    ItemFields.id: id,
    ItemFields.ownerid: ownerid,
    ItemFields.name: name,
    ItemFields.description: description,
    ItemFields.price: price,
    ItemFields.imageURL: imageURL,
    ItemFields.inventory: inventory
  };
}