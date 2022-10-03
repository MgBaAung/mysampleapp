class ProductField {
  static const String productTable = "Product";
  static const String name = "name";
  static const String id = "id";
  static const String qty = "quantity";
  static const String minQty = "min_quantity";
  static const String date = "date";
  static const String isTrash = "is_trash"; 
  static const String warehouse = "warehouse";
}

class Product {
  int id;
  String name;
  int quantity;
  int minQuantity;
  DateTime date;
  bool isTrash;
  String warehouse;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.minQuantity,
    required this.date,
    required this.isTrash,
    required this.warehouse,
  });

  factory Product.fromMap(Map<String, dynamic> json) => new Product(
        id: json[ProductField.id],
        name: json[ProductField.name],
        quantity: json[ProductField.qty],
        minQuantity: json[ProductField.minQty],
        date: DateTime.parse(json[ProductField.date]),
        isTrash: json[ProductField.isTrash]==0?false:true,
        warehouse: json[ProductField.warehouse],
      );

  Map<String, dynamic> toMap() => {
        ProductField.id: id,
        ProductField.name: name,
        ProductField.qty: quantity,
        ProductField.minQty: minQuantity,
        ProductField.date: date.toIso8601String(),
        ProductField.isTrash: isTrash?1:0,
        ProductField.warehouse: warehouse
      };

  Product copyWith({
    int? id,
    String? name,
    int? quantity,
    int? minQuantity,
    DateTime? date,
    bool? isTrash,
    String? warehouse,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      date: date ?? this.date,
      isTrash: isTrash ?? this.isTrash,
      warehouse: warehouse ?? this.warehouse,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, quantity: $quantity, minQuantity: $minQuantity, date: $date, isTrash: $isTrash, warehouse: $warehouse)';
  }
}
