import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:warehouse/data/database.dart';
import 'package:warehouse/model/warehouse.dart';
import 'package:warehouse/theme.dart';
import 'package:warehouse/widgets/drawer.dart';
import 'model/produt.dart';
import 'screen/add_product_screen.dart';
import 'screen/warehouse_screen.dart';
import 'screen/search_screen.dart';
import 'widgets/CardForMainPageProducts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      title: "WareHouse",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  int alertcount = 0;
  int nofpro = 0;
  String? godownname;
  List<Warehouse> gdnameforpopitem = [];

  @override
  void initState() {
    super.initState();
    getGodownName();
    getMinQty();
    getNoOfProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
          ),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        elevation: 0,
        title: Text(
          "My Products",
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
                  pageBuilder: (c, a1, a2) => SearchProduct(godownname),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 5),
                ),
              );
            },
          ),
          PopupMenuButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Icon(
                Icons.warehouse,
              ),
            ),
            itemBuilder: (context) {
              List<PopupMenuEntry<String>> list = [];
              if (gdnameforpopitem.isEmpty) {
                list.add(
                  PopupMenuItem(
                    child: TextButton(
                      child: Text(
                          "You don't have Warehouse! Click here to create Warehouse"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) => WarehouseScreen(),
                            transitionsBuilder: (c, anim, a2, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration: Duration(milliseconds: 5),
                          ),
                        );
                      },
                    ),
                    value: "",
                  ),
                );
              } else {
                list.add(PopupMenuItem(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextButton(
                        child: Text("All Products"),
                        onPressed: () {
                          setState(() {
                            godownname = null;
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  ),
                  value: "",
                ));
                for (int i = 0; i < gdnameforpopitem.length; i++) {
                  Warehouse godown = gdnameforpopitem[i];
                  list.add(
                    PopupMenuItem(
                      child: Text("(${i + 1})  ${godown.name}"),
                      value: "${godown.name}",
                    ),
                  );
                }
              }

              return list;
            },
            onSelected: (String value) => {
              setState(() {
                godownname = value;
              })
            },
          ),
        ],
      ),
      drawer: AppDrawer(
        count: alertcount,
        productcount: nofpro,
      ),
      body: DoubleBackToCloseApp(
        child: godownname != null
            ? FutureBuilder<List<Product>>(
                future: DBProvider.db.getProductsByWarehouseName(godownname!),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.hasData) {
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
                                    setState(
                                      () {
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
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                            child: cardForListile(context, item),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            : FutureBuilder<List<Product>>(
                future: DBProvider.db.getAllProducts(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot,
                ) {
                  if (snapshot.hasData) {
                    if (snapshot.data?.isEmpty == true) {
                      return Center(
                        child: Text(
                          "Add some products",
                          style: TextStyle(fontSize: 20),
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
                            key: ValueKey(item.id),
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  label: 'Trash',
                                  backgroundColor: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                  icon: Icons.delete,
                                  onPressed: (_) {
                                    setState(
                                      () {
                                        DBProvider.db.trashProduct(item);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 1),
                                            content: Text(
                                              "Moved to trash.",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                            child: cardForListile(context, item),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
        snackBar: const SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            "Tap back again to leave!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 40,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => AddProduct(" Add ", null),
            ),
          );
          setState(() {});
        },
      ),
    );
  }

  getGodownName() async {
    gdnameforpopitem = await DBProvider.db.getAllWarehouse();
  }

  void getMinQty() async {
    alertcount = await DBProvider.db.getCountOfProductsUnderMinQty();
  }

  void getNoOfProducts() async {
    nofpro = await DBProvider.db.getProductCount();
  }
}
