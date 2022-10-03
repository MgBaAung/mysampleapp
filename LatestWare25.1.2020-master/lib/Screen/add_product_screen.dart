import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/model/produt.dart';
import 'package:warehouse/model/warehouse.dart';
import 'package:warehouse/widgets/AlertforAlert.dart';
import '../data/database.dart';
import 'warehouse_screen.dart';

class AddProduct extends StatefulWidget {
  final String name;
  final Product? product;

  AddProduct(this.name, this.product);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final qtyController = TextEditingController();
  final minQtyController = TextEditingController();

  String warehouse = "Choose a Godown";

  List<Warehouse> warehouseList = [];

  @override
  void initState() {
    super.initState();
    getGodownName();
    nameController.text = widget.product?.name ?? "";
    qtyController.text = widget.product?.quantity == null
        ? ""
        : widget.product!.quantity.toString();
    minQtyController.text = widget.product?.minQuantity == null
        ? ""
        : widget.product!.minQuantity.toString();
    warehouse = widget.product?.warehouse ?? "Choose a Godown";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Add Product",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: nameController,
                    onChanged: (value) {
                      widget.product?.name = nameController.text;
                    },
                    validator: (String? value) {
                      if (value == "") {
                        return "Please enter product name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text('Name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      widget.product?.quantity = int.parse(qtyController.text);
                    },
                    validator: (qty) {
                      if (qty == "") {
                        return "Please enter quantity";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text('Quanitity'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      widget.product?.minQuantity =
                          int.parse(minQtyController.text);
                    },
                    validator: (minqty) {
                      if (minqty == "") {
                        return "Minimun quantity required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text('Minimun Quanitity'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller: minQtyController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  PopupMenuButton<String>(
                    itemBuilder: (context) {
                      List<PopupMenuEntry<String>> list = [];
                      if (warehouseList.isEmpty) {
                        list.add(
                          PopupMenuItem(
                            child: TextButton(
                              child: Text(
                                  "You don't have Warehouse! Click here to create Warehouse"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) =>
                                        WarehouseScreen(),
                                    transitionsBuilder: (c, anim, a2, child) =>
                                        FadeTransition(
                                            opacity: anim, child: child),
                                    transitionDuration:
                                        Duration(milliseconds: 5),
                                  ),
                                );
                              },
                            ),
                            value: "",
                          ),
                        );
                      } else {
                        for (int i = 0; i < warehouseList.length; i++) {
                          Warehouse _godown = warehouseList[i];
                          list.add(
                            PopupMenuItem(
                              child: Text("${_godown.name}"),
                              value: "${_godown.name}",
                            ),
                          );
                        }
                      }

                      return list;
                    },
                    onSelected: (value) => {
                      setState(() {
                        warehouse = value;
                      })
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            warehouse,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 30,
                        ),
                        SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          child: Text('Clear'),
                          onPressed: () {
                            setState(() {
                              nameController.clear();
                              qtyController.clear();
                              minQtyController.clear();
                              warehouse = "Choose a Warehouse";
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          child: Text(widget.name),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final _minQty = int.parse(minQtyController.text);
                              final _qty = int.parse(qtyController.text);

                              if (widget.name == " Add ") {
                                if (_qty > 0 && _minQty > 0) {
                                  DBProvider.db.createProduct(
                                    Product(
                                      id: DateTime.now().millisecondsSinceEpoch,
                                      name: nameController.text,
                                      quantity: _qty,
                                      minQuantity: _minQty,
                                      warehouse: warehouse,
                                      date: DateTime.now(),
                                      isTrash: false,
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  showAlert(context,
                                      "Quantity must be greater than 0");
                                }

                                //product update
                              } else {
                                if (_qty > 0 && _minQty > 0) {
                                  DBProvider.db.updateProduct(
                                    widget.product!.copyWith(
                                      name: nameController.text,
                                      date: DateTime.now(),
                                      quantity: int.parse(qtyController.text),
                                      minQuantity:
                                          int.parse(minQtyController.text),
                                    ),
                                  );
                                  DBProvider.db.updateSellListWithEditedProduct(
                                    name: nameController.text,
                                    godown: warehouse,
                                    productId: widget.product!.id,
                                  );
                                  DBProvider.db.updateBuyListWithEditedProduct(
                                    name: nameController.text,
                                    godown: warehouse,
                                    productId: widget.product!.id,
                                  );
                                  Navigator.pop(context);
                                } else {
                                  showAlert(context,
                                      "Quantity must be greater than 0");
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  getGodownName() async {
    warehouseList = await DBProvider.db.getAllWarehouse();
  }
}
