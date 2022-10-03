class BuySellField {
  static const String buyTable = "BuyList";
  static const String sellTable = "SellList";
  static const String id = "id";
  static const String productId = "product_id";
  static const String name = "name";
  static const String qty = "quantity";
  static const String date = "date";
  static const String warehouse = "warehouse";
}

class BuySellProduct {
  int id;
  int productId;
  String name;
  int quantity;
  DateTime date;
  String warehouse;

  BuySellProduct({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.date,
    required this.warehouse,
  });

  factory BuySellProduct.fromMap(Map<String, dynamic> json) =>
      new BuySellProduct(
        id: json[BuySellField.id],
        name: json[BuySellField.name],
        quantity: json[BuySellField.qty],
        date: DateTime.parse(json[BuySellField.date]),
        warehouse: json[BuySellField.warehouse],
        productId: json[BuySellField.productId],
      );

  Map<String, dynamic> toMap() => {
        BuySellField.id: id,
        BuySellField.name: name,
        BuySellField.qty: quantity,
        BuySellField.date: date.toIso8601String(),
        BuySellField.warehouse: warehouse,
        BuySellField.productId: productId
      };

  BuySellProduct copyWith({
    int? id,
    int? productId,
    String? name,
    int? quantity,
    DateTime? date,
    String? warehouse,
  }) {
    return BuySellProduct(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      date: date ?? this.date,
      warehouse: warehouse ?? this.warehouse,
    );
  }

  @override
  String toString() {
    return 'BuyList(id: $id, productId: $productId, name: $name, quantity: $quantity, date: $date, warehouse: $warehouse)';
  }
}
