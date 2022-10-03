import 'package:flutter/material.dart';
import 'package:warehouse/model/produt.dart';

import 'AlertForProductDetail.dart';
import 'DialogMenu.dart';
import 'colorforlistile.dart';

cardforproductSearch(BuildContext context, Product item) {
  return Card(
    child: ListTile(
      title: Text(
        item.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: CircleAvatar(
          backgroundColor: colorforlistile(item),
          child: Text(
            item.name.substring(0, 1),
            style: TextStyle(color: Colors.white),
          )),
      subtitle: Text(item.date.toIso8601String()),
      trailing: Text(item.quantity.toString()),
      onTap: () {
        dialogmenu(context, item);
      },
      onLongPress: () {
        showProductDetail(context, item);
      },
    ),
  );
}
