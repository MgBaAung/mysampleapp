import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:warehouse/model/buy_sell_product.dart';
import 'package:warehouse/screen/buy/date_search_buylist.dart';
import 'package:warehouse/screen/buy/search_buylist.dart';
import 'package:warehouse/widgets/AlertForBuylistDetail.dart';
import 'package:warehouse/widgets/AlertforAlert.dart';

import '../../data/database.dart';
import '../../widgets/product_delete_dialog.dart';

int? hasdata;

class BuylistScreen extends StatefulWidget {
  @override
  _BuylistScreenState createState() => _BuylistScreenState();
}

class _BuylistScreenState extends State<BuylistScreen> {
  String? firstdate;
  String? seconddate;

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
            "Buylist",
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                CupertinoIcons.search,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => SearchBuylistScreen(),
                    transitionsBuilder: (c, anim, a2, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: Duration(milliseconds: 1),
                  ),
                );
              },
            ),
            SizedBox(
              width: 9,
            )
          ]),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 6,
            child: Container(
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton.icon(
                    icon: Icon(Icons.calendar_today),
                    label:
                        Text("${firstdate == null ? 'Start Date' : firstdate}"),
                    onPressed: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(2020, 1, 1),
                        maxTime: DateTime(2030, 12, 31),
                        onChanged: (date) {
                          print(date);
                          setState(() {
                            firstdate = date.toString().substring(0, 10);
                            print(firstdate);
                          });
                        },
                        onConfirm: (date) {
                          setState(() {
                            firstdate = date.toString().substring(0, 10);
                          });
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.en,
                      );
                    },
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.calendar_today),
                    label:
                        Text("${seconddate == null ? 'End Date' : seconddate}"),
                    onPressed: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(2020, 1, 1),
                        maxTime: DateTime(2030, 12, 31),
                        onChanged: (date) {
                          setState(() {
                            seconddate = date.toString().substring(0, 10);
                            print(seconddate);
                          });
                        },
                        onConfirm: (date) {
                          setState(() {
                            seconddate = date.toString().substring(0, 10);
                          });
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.en,
                      );
                    },
                  ),
                  TextButton.icon(
                    icon: Icon(CupertinoIcons.search),
                    label: Text("Search"),
                    onPressed: () {
                      if (firstdate != null && seconddate != null) {
                        if (DateTime.parse(firstdate!)
                            .isBefore(DateTime.parse(seconddate!))) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => DateSearchBuyList(
                                  firstdate == null
                                      ? DateTime.now()
                                          .toString()
                                          .substring(0, 10)
                                      : firstdate!,
                                  seconddate!),
                              transitionsBuilder: (c, anim, a2, child) =>
                                  FadeTransition(opacity: anim, child: child),
                              transitionDuration: Duration(milliseconds: 1),
                            ),
                          );
                        } else {
                          showAlert(context, "Invalid Date");
                        }
                      } else {
                        showAlert(context,
                            "Select Both first Date and last Date first!");
                      }
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
            child: FutureBuilder<List<BuySellProduct>>(
              future: DBProvider.db.getAllbuyList(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<BuySellProduct>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      BuySellProduct item = snapshot.data![index];
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, top: 8),
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
                                            .deleteBuylist(item.id);
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
                                buylistDetail(context, item);
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
}
