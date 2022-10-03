import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/screen/sell_buy_screen.dart';

import '../model/produt.dart';
import '../screen/add_product_screen.dart';

var sellcon = TextEditingController();

dialogmenu(BuildContext context, Product product) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 211,
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CupertinoButton(
                  child: Text(
                    "BUY ( + )",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            SellandBuyProductScreen("Buy", product),
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  height: 1,
                ),
                CupertinoButton(
                  child: Text(
                    "SELL ( - )",
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            SellandBuyProductScreen("Sell", product),
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  height: 1,
                ),
                CupertinoButton(
                  child: Text(
                    "EDIT",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => AddProduct("Update", product),
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  height: 1,
                ),
                CupertinoButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      });
}
