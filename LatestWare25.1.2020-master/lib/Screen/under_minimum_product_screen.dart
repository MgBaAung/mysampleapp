import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:warehouse/model/produt.dart';
import 'package:warehouse/widgets/AlertForProductDetail.dart';
import 'package:warehouse/widgets/DialogMenu.dart';
import '../data/database.dart';

class ProductUnderMin extends StatefulWidget {
  @override
  _ProductUnderMinState createState() => _ProductUnderMinState();
}

class _ProductUnderMinState extends State<ProductUnderMin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
          "Products under minimum",
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: DBProvider.db.getProductsUnderMinQty(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.isEmpty == true) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.emoji_emotions,
                        size: 70,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No product is under minimun quantity.",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                Product item = snapshot.data![index];

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
                            label: 'Trash',
                            backgroundColor: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                            icon: Icons.delete,
                            onPressed: (_) {
                              setState(() {});
                              DBProvider.db.trashProduct(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text(
                                    "moved to trash.",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }),
                      ],
                    ),
                    child: Card(
                      child: ListTile(
                          title: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: CircleAvatar(
                              maxRadius: 20,
                              backgroundColor: Colors.red,
                              child: Text(
                                item.name.substring(0, 1),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              )),
                          subtitle: Text(item.date.toIso8601String()),
                          trailing: Text(item.quantity.toString()),
                          onTap: () {
                            dialogmenu(context, item);
                          },
                          onLongPress: () {
                            showProductDetail(context, item);
                          }),
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
    );
  }
}
