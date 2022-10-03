class WarehouseField {
  static const String warehouseTable = "Warehouse";
  static const String id = "id";
  static const String name = "name";
  static const String date = "date";
}

class Warehouse {
  int id;
  String name;
  DateTime date;

  Warehouse({
    required this.id,
    required this.name,
    required this.date,
  });

  factory Warehouse.fromMap(Map<String, dynamic> json) => new Warehouse(
        id: json[WarehouseField.id],
        name: json[WarehouseField.name],
        date: DateTime.parse(
          json[WarehouseField.date],
        ),
      );

  Map<String, dynamic> toMap() => {
        WarehouseField.id: id,
        WarehouseField.name: name,
        WarehouseField.date: date.toIso8601String(),
      };
}
