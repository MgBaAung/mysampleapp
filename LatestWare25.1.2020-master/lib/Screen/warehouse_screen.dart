import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:warehouse/model/warehouse.dart';
import 'package:warehouse/widgets/AlertforAlert.dart';

import '../data/database.dart';

class WarehouseScreen extends StatefulWidget {
  @override
  _WarehouseScreenState createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen> {
  var warehousTextController = TextEditingController();
  var updateTextController = TextEditingController();
  var nofproducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Warehouse",
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: TextField(
                      controller: warehousTextController,
                      maxLines: 1,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: "Enter Warehouse name",
                        prefixIcon: Icon(
                          Icons.store,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    child: Text(
                      "Create",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () async {
                      setState(() {
                        if (warehousTextController.text.isNotEmpty) {
                          DBProvider.db.createWarehouse(
                            Warehouse(
                              id: DateTime.now().millisecondsSinceEpoch,
                              date: DateTime.now(),
                              name: warehousTextController.text,
                            ),
                          );
                          warehousTextController.text = "";
                        } else {
                          showAlert(context, "Warehouse already exist.");
                        }
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<Warehouse>>(
              future: DBProvider.db.getAllWarehouse(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Warehouse>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Warehouse item = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          right: 8,
                          left: 8,
                        ),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                  label: 'Delete',
                                  backgroundColor: Colors.red,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(4),
                                  ),
                                  icon: Icons.delete,
                                  onPressed: (_) async {
                                    await getNumberOfproducts(item.name);
                                    setState(() {
                                      print(nofproducts);
                                      _showDialog(item.id, item.name);
                                    });
                                  }),
                              SlidableAction(
                                  label: 'Edit',
                                  backgroundColor: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                  icon: Icons.edit,
                                  onPressed: (_) {
                                    updateGodown(context, item);
                                  })
                            ],
                          ),
                          child: Card(
                            child: ListTile(
                              subtitle: Text(item.date.toIso8601String()),
                              leading: CircleAvatar(
                                child: Icon(
                                  Icons.store,
                                  size: 30,
                                ),
                              ),
                              title: Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () async {
                                await getNumberOfproducts(item.name);
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text(
                                      "${item.name}",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    content:
                                        Text("Total Product: $nofproducts"),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  getNumberOfproducts(String gdname) async {
    nofproducts = await DBProvider.db.getProductCountByWarehouse(gdname);
  }

  void _showDialog(int id, String gdname) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you Sure!"),
          content: nofproducts == 0
              ? Text("There is no products in this warehouse.")
              : Text(
                  "You have $nofproducts Product${nofproducts == 1 ? "" : "s"} in this Warehouse.",
                ),
          actions: <Widget>[
            TextButton(
              child: new Text(" No "),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: 5,
            ),
            ElevatedButton(
              child: Text("Delete"),
              onPressed: () async {
                await DBProvider.db.deleteWarehouse(id);
                await DBProvider.db.deleteProductWithGodownName(gdname);
                setState(() async {});

                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void updateGodown(BuildContext context, Warehouse item) {
    updateTextController.text = item.name;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Edit Warehouse's Name",
          ),
          content: Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    controller: updateTextController,
                    autofocus: true,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 10),
            ElevatedButton(
              child: Text(
                "Update",
                style: TextStyle(fontSize: 15),
              ),
              onPressed: () async {
                if (updateTextController.text != "") {
                  DBProvider.db.updateWarehouse(Warehouse(
                      date: item.date,
                      id: item.id,
                      name: updateTextController.text));
                  DBProvider.db.updateProductByWarehouse(
                    newWH: updateTextController.text,
                    oldWH: item.name,
                  );
                  DBProvider.db.updateBuyListWithWarehouseName(
                      updateTextController.text, item.name);
                  DBProvider.db.updateSellListWithNewWarehouseName(
                      updateTextController.text, item.name);
                  Navigator.of(context).pop();
                } else {
                  showAlert(context, "Warehouse's Name can't be Empty");
                }
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}
