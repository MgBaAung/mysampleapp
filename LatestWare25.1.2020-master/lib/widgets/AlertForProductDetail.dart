import 'package:flutter/material.dart';
import 'package:warehouse/model/produt.dart';

void showProductDetail(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0)), //t
        content: Container(
          width: 200,
          height: 200,
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Name",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    "${product.name}",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Quantity",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${product.quantity}",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Warehouse",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${product.warehouse}",
                    style: TextStyle(fontSize: 20),
                  ),
//                  Text(
//                    "Date:",
//                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                  ),
//                  Text(
//                    "${product.date}",
//                    style: TextStyle(fontSize: 20),
//                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
