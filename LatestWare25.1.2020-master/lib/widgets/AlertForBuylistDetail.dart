import 'package:flutter/material.dart';
import 'package:warehouse/model/buy_sell_product.dart';

var sellcon = TextEditingController();

buylistDetail(BuildContext context, BuySellProduct list) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0)), //this right here

          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              height: 200,
              width: 100,
              child: ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Name:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${list.name}",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Quantity:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${list.quantity}",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Warehouse:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${list.warehouse}",
                        style: TextStyle(fontSize: 20),
                      ),
//
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
}
