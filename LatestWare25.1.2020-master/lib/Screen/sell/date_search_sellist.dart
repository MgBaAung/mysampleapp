import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:warehouse/model/buy_sell_product.dart';
import 'package:warehouse/widgets/AlertForSellistDetail.dart';

import '../../data/database.dart';
import '../../widgets/product_delete_dialog.dart';

class DateSearchSellist extends StatefulWidget {
  final String firstdate;
  final String seconddate;

  DateSearchSellist(this.firstdate, this.seconddate);

  @override
  _DateSearchSellistState createState() =>
      _DateSearchSellistState(this.firstdate, this.seconddate);
}

class _DateSearchSellistState extends State<DateSearchSellist> {
  String firstdate;
  String seconddate;

  _DateSearchSellistState(this.firstdate, this.seconddate);

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
        title: Text("Search Result"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 8.0),
        child: FutureBuilder<List<BuySellProduct>>(
          future: DBProvider.db.getSellListByDate(firstdate, seconddate),
          builder: (BuildContext context,
              AsyncSnapshot<List<BuySellProduct>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  BuySellProduct item = snapshot.data![index];
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
    );
  }
}
