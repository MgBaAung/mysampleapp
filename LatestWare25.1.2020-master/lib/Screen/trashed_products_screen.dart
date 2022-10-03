import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:warehouse/widgets/colorforlistile.dart';
import '../data/database.dart';
import '../model/produt.dart';
import '../widgets/product_delete_dialog.dart';

class TrashedProducts extends StatefulWidget {
  @override
  _TrashedProductsState createState() => _TrashedProductsState();
}

class _TrashedProductsState extends State<TrashedProducts> {
  int noftrashedpro = 0;
  @override
  void initState() {
    super.initState();
    getNoofTrashedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Trashed Products",
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: DBProvider.db.getTrashedProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.isEmpty == true) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_forever,
                      size: 70,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "No products in trash!",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                Product item = snapshot.data![index];
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
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
                          onPressed: (_) {
                            showProductDeleteDialog(
                              context: context,
                              callback: () async {
                                await DBProvider.db.deleteProductById(item.id);
                                setState(() {});
                              },
                            );
                          },
                        ),
                        SlidableAction(
                          label: 'Restore',
                          backgroundColor: Colors.green,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                          icon: Icons.restore_from_trash,
                          onPressed: (_) {
                            setState(
                              () {
                                DBProvider.db.restoreTrashedProduct(item);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                      "Restored successfully.",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                    child: Card(
                      child: ListTile(
                        subtitle: Text(
                          item.date.toIso8601String(),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: colorforlistile(item),
                          child: Text(
                            item.name.substring(0, 1),
                          ),
                        ),
                        title: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Icon(
                          CupertinoIcons.back,
                          color: Colors.red,
                          size: 35,
                        ),
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
    );
  }

  void getNoofTrashedProducts() async {
    noftrashedpro = await DBProvider.db.getCountOfTrashedProducts();
  }
}
