import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:warehouse/widgets/AlertForSellistDetail.dart';

import '../../model/buy_sell_product.dart';
import '../../data/database.dart';
import '../../widgets/product_delete_dialog.dart';

class SearchSellistScreen extends StatefulWidget {
  @override
  _SearchSellistScreenState createState() => _SearchSellistScreenState();
}

class _SearchSellistScreenState extends State<SearchSellistScreen> {
  @override
  initState() {
    consearch.addListener(() {
      setState(() {
        filter = consearch.text.toLowerCase();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    consearch.dispose();
    super.dispose();
  }

  var consearch = TextEditingController();
  String? filter;

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
        title: CupertinoTextField(
          controller: consearch,
          autofocus: true,
          prefix: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              CupertinoIcons.search,
            ),
          ),
          placeholder: "Search",
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white12
                  : Colors.black12,
            ),
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      body: FutureBuilder<List<BuySellProduct>>(
        future: DBProvider.db.getAllsellist(),
        builder: (BuildContext context,
            AsyncSnapshot<List<BuySellProduct>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                BuySellProduct item = snapshot.data![index];

                return filter == null || filter == ""
                    ? Padding(
                        padding:
                            const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                        child: Slidable(
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                    label: 'Delete',
                                    backgroundColor: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                    icon: Icons.delete,
                                    onPressed: (_) {
                                      showProductDeleteDialog(
                                        context: context,
                                        callback: () async {
                                          await DBProvider.db
                                              .deleteSellProduct(item.id);
                                          setState(() {});
                                        },
                                      );
                                    }),
                              ],
                            ),
                            child: Card(
                                child: ListTile(
                              onTap: () {
                                sellistDetail(context, item);
                              },
                              subtitle: Text(item.date.toIso8601String()),
                              leading: CircleAvatar(
                                  child: Text(item.name.substring(0, 1))),
                              title: Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(item.quantity.toString()),
                            ))),
                      )
                    : item.name.toLowerCase().contains(filter!)
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, right: 8, left: 8),
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    label: 'Delete',
                                    backgroundColor: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                    icon: Icons.delete,
                                    onPressed: (_) {
                                      showProductDeleteDialog(
                                        context: context,
                                        callback: () async {
                                          await DBProvider.db
                                              .deleteSellProduct(item.id);
                                          setState(() {});
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    sellistDetail(context, item);
                                  },
                                  subtitle: Text(item.date.toIso8601String()),
                                  leading: CircleAvatar(
                                      child: Text(item.name.substring(0, 1))),
                                  title: Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Text(item.quantity.toString()),
                                ),
                              ),
                            ),
                          )
                        : Container();
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
