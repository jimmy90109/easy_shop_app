final String tableBuyers = 'buyers';

class BuyerFields {
  static final List<String> values = [
    id, name, phone, email, password, review, reviewCount
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String phone = 'phone';
  static final String email = 'email';
  static final String password = 'password';
  static final String review = 'review';
  static final String reviewCount = 'reviewCount';
}

class Buyer {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String password;
  final num review;
  final int reviewCount;

  const Buyer({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.review,
    required this.reviewCount,
  });

  Buyer copy({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? password,
    num? review,
    int? reviewCount,
  }) =>
      Buyer(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        password: password ?? this.password,
        review: review ?? this.review,
        reviewCount: reviewCount ?? this.reviewCount,
      );

  static Buyer fromJson(Map<String, Object?> json) => Buyer(
    id: json[BuyerFields.id] as int?,
    name: json[BuyerFields.name] as String,
    phone: json[BuyerFields.phone] as String,
    email: json[BuyerFields.email] as String,
    password: json[BuyerFields.password] as String,
    review: json[BuyerFields.review] as num,
    reviewCount: json[BuyerFields.reviewCount] as int,
  );

  Map<String, Object?> toJson() => {
    BuyerFields.id: id,
    BuyerFields.email: email,
    BuyerFields.name: name,
    BuyerFields.phone: phone,
    BuyerFields.password: password,
    BuyerFields.review: review,
    BuyerFields.reviewCount: reviewCount,
  };
}