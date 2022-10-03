import 'package:flutter/material.dart';
import 'package:warehouse/screen/BackupDataScreen.dart';
import 'package:warehouse/screen/about_screen.dart';
import 'package:warehouse/screen/buy/buylist_screen.dart';
import 'package:warehouse/screen/warehouse_screen.dart';
import 'package:warehouse/screen/sell/sellist_screen.dart';

import '../screen/trashed_products_screen.dart';
import '../screen/under_minimum_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
    required this.count,
    required this.productcount,
  }) : super(key: key);

  final int count;
  final int productcount;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "Manage Products",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text(
                          "Products",
                          style: TextStyle(fontSize: 17),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: CircleAvatar(
                            child: Text(
                              "$productcount",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.shopping_cart),
                        title: Text(
                          "Buy List",
                          style: TextStyle(fontSize: 17),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BuylistScreen()));
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.shop),
                        title: Text(
                          "Sell List",
                          style: TextStyle(fontSize: 17),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SellistScreen()));
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.report),
                        title: Text(
                          "Notification",
                          style: TextStyle(fontSize: 17),
                        ),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductUnderMin()));
                          //  Navigator.pop(context);
                        },
                        trailing: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: CircleAvatar(
                            child: Text(
                              "$count",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.store),
                        title: Text(
                          "Warehouse",
                          style: TextStyle(fontSize: 17),
                        ),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WarehouseScreen()));
                          //  Navigator.pop(context);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.restore_from_trash),
                        title: Text(
                          "Trash",
                          style: TextStyle(fontSize: 17),
                        ),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrashedProducts()));
                          // Navigator.pop(context);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.content_copy),
                        title: Text(
                          "Copy Data",
                          style: TextStyle(fontSize: 17),
                        ),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Copydata()));
                          //  Navigator.pop(context);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.person,
                        ),
                        title: Text(
                          "About",
                          style: TextStyle(fontSize: 17),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => About()));
                        },
                      )
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
}
