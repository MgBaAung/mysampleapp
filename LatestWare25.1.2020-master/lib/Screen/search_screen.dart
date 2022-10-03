import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:warehouse/model/produt.dart';
import 'package:warehouse/widgets/CardForProductSearchPage.dart';

import '../data/database.dart';

class SearchProduct extends StatefulWidget {
  final String? godownname;

  SearchProduct(this.godownname);

  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  @override
  initState() {
    super.initState();
    searchTextController.addListener(() {
      setState(() {
        filter = searchTextController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  var searchTextController = TextEditingController();
  String? filter;

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
        title: SizedBox(
          height: 45,
          child: TextField(
            controller: searchTextController,
            textAlignVertical: TextAlignVertical.center,
            maxLines: 1,
            autofocus: true,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.2,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.5)
                      : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              hintText: "Search",
              prefixIcon: Icon(
                CupertinoIcons.search,
              ),
            ),
          ),
        ),
      ),
      body: widget.godownname != null
          ? FutureBuilder<List<Product>>(
              future:
                  DBProvider.db.getProductsByWarehouseName(widget.godownname!),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Product item = snapshot.data![index];

                      return filter == null || filter == ""
                          ? Padding(
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
                                          DBProvider.db.trashProduct(item);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                "moved to trash.",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.redAccent,
                                            ),
                                          );
                                          setState(() {});
                                        })
                                  ],
                                ),
                                child: cardforproductSearch(context, item),
                              ),
                            )
                          : item.name.toLowerCase().contains(filter!)
                              ? Padding(
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
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            icon: Icons.delete,
                                            onPressed: (_) {
                                              DBProvider.db.trashProduct(item);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content: Text(
                                                    "moved to trash.",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                ),
                                              );
                                              setState(() {});
                                            })
                                      ],
                                    ),
                                    child: cardforproductSearch(context, item),
                                  ),
                                )
                              : new Container();
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          : FutureBuilder<List<Product>>(
              future: DBProvider.db.getAllProducts(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Product item = snapshot.data![index];

                      return filter == null || filter == ""
                          ? Padding(
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
                                        DBProvider.db.trashProduct(item);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 1),
                                            content: Text(
                                              "moved to trash.",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                                child: cardforproductSearch(context, item),
                              ),
                            )
                          : item.name.toLowerCase().contains(filter!)
                              ? Padding(
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
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          icon: Icons.delete,
                                          onPressed: (_) {
                                            setState(() {});
                                            DBProvider.db.trashProduct(item);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Text(
                                                  "moved to trash.",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor:
                                                    Colors.redAccent,
                                              ),
                                            );
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                    child: cardforproductSearch(context, item),
                                  ),
                                )
                              : new Container();
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
