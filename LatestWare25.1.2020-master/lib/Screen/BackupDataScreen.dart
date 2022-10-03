import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import '../data/database.dart';

class Copydata extends StatefulWidget {
  @override
  _CopydataState createState() => _CopydataState();
}

class _CopydataState extends State<Copydata> {
  String? seleabletextData;
  String? appbartitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          appbartitle ?? "Choose table >",
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            seleabletextData = null;
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.view_list,
            ),
            itemBuilder: (context) {
              List<PopupMenuEntry<Object>> list = [];

              list.add(
                PopupMenuItem(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextButton(
                        child: Text(
                          "Products",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          allProducts();

                          appbartitle = "Products";
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  value: "Products",
                ),
              );

              list.add(PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextButton(
                      child: Text(
                        "Sellist",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        sellists();
                        print(seleabletextData);
                        appbartitle = "Sellist";
                        setState(() {});
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                value: "Sellist",
              ));

              list.add(PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextButton(
                      child: Text(
                        "Buylist",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        buylists();

                        appbartitle = "Buylist";
                        setState(() {});
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                value: "Buylist",
              ));

              list.add(PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextButton(
                      child: Text(
                        "Warehouse",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        godowns();

                        appbartitle = "Warehouse";
                        setState(() {});
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                value: "Warehouse",
              ));

              return list;
            },
            onSelected: (value) => {},
          ),
        ],
      ),
      body: seleabletextData != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(seleabletextData ?? "No Data!"),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Text(
                "Select Table to see and copy data!",
                style: TextStyle(fontSize: 20),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.content_copy),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: seleabletextData));
          Toast.show(
            "Copied to Clipboard",
          );
        },
      ),
    );
  }

  void allProducts() async {
    List<List<dynamic>> allproductlist = [];

    var maplist = await DBProvider.db.getAllProducts();

    for (int i = 0; i < maplist.length; i++) {
      List<dynamic> row = [
        maplist[i].id,
        maplist[i].name,
        maplist[i].quantity,
        maplist[i].minQuantity,
        maplist[i].date,
        maplist[i].warehouse
      ];
      allproductlist.add(row);
    }

    String csv = const ListToCsvConverter().convert(allproductlist);

//  var csvtolist=const CsvToListConverter().convert(csv);
//  print(csvtolist);

    seleabletextData = csv;
  }

  void sellists() async {
    List<List<dynamic>> sellist = [];

    var maplist = await DBProvider.db.getAllsellist();

    for (int i = 0; i < maplist.length; i++) {
      List<dynamic> row = [
        maplist[i].id,
        maplist[i].name,
        maplist[i].quantity,
        maplist[i].date,
        maplist[i].warehouse
      ];
      sellist.add(row);
    }

    String csv = const ListToCsvConverter().convert(sellist);
    print(csv);
    seleabletextData = csv;
  }

  void buylists() async {
    List<List<dynamic>> buylist = [];

    var maplist = await DBProvider.db.getAllbuyList();

    for (int i = 0; i < maplist.length; i++) {
      List<dynamic> row = [
        maplist[i].id,
        maplist[i].name,
        maplist[i].quantity,
        maplist[i].date,
        maplist[i].warehouse
      ];
      buylist.add(row);
    }

    String csv = const ListToCsvConverter().convert(buylist);
    print(csv);
    seleabletextData = csv;
  }

  void godowns() async {
    List<List<dynamic>> godown = [];

    var maplist = await DBProvider.db.getAllWarehouse();

    for (int i = 0; i < maplist.length; i++) {
      List<dynamic> row = [
        maplist[i].id,
        maplist[i].name,
        maplist[i].date,
      ];
      godown.add(row);
    }

    String csv = const ListToCsvConverter().convert(godown);

    seleabletextData = csv;
  }
}
