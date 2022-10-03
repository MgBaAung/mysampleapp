import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/model/buy_sell_product.dart';
import 'package:warehouse/model/produt.dart';
import 'package:warehouse/widgets/AlertforAlert.dart';

import '../data/database.dart';

class SellandBuyProductScreen extends StatefulWidget {
  final String name;
  final Product product;

  SellandBuyProductScreen(this.name, this.product);

  @override
  _SellandBuyProductScreenState createState() =>
      _SellandBuyProductScreenState(this.name, this.product);
}

class _SellandBuyProductScreenState extends State<SellandBuyProductScreen> {
  var qtyTextController = TextEditingController();
  var conprice = TextEditingController();

  String name;
  Product product;

  _SellandBuyProductScreenState(this.name, this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("$name Product"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  product.name,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Total: ${product.quantity}",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        qtyTextController.clear();
                      },
                      icon: Icon(Icons.clear_rounded),
                    ),
                    hintText: 'Enter quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  controller: qtyTextController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            name == "Sell" ? Colors.red : Colors.green,
                      ),
                      child: Text(name),
                      onPressed: () async {
                        if (qtyTextController.text != "") {
                          if (int.parse(qtyTextController.text) > 0) {
                            if (name == "Sell") {
                              if (int.parse(qtyTextController.text) <=
                                  product.quantity) {
                                await DBProvider.db.sellProduct(
                                    product, int.parse(qtyTextController.text));
                                await DBProvider.db.createSellProduct(
                                  BuySellProduct(
                                    id: DateTime.now().millisecondsSinceEpoch,
                                    name: product.name,
                                    quantity: int.parse(qtyTextController.text),
                                    warehouse: product.warehouse,
                                    date: DateTime.now(),
                                    productId: product.id,
                                  ),
                                );

                                Navigator.pop(context);
                              } else {
                                showAlert(
                                    context, "You don't have enough quantity");
                              }
                            } else {
                              DBProvider.db.buyProduct(
                                  product, int.parse(qtyTextController.text));
                              DBProvider.db.createBuyProduct(
                                BuySellProduct(
                                  id: DateTime.now().millisecondsSinceEpoch,
                                  name: product.name,
                                  quantity: int.parse(qtyTextController.text),
                                  warehouse: product.warehouse,
                                  date: DateTime.now(),
                                  productId: product.id,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          } else {
                            showAlert(
                                context, "Quantity must be greater than 0");
                          }
                        } else {
                          showAlert(context, "Please Enter Qunatity!");
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
