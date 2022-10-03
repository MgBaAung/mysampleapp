import 'package:flutter/material.dart';
import 'package:warehouse/model/produt.dart';

import 'AlertForProductDetail.dart';
import 'DialogMenu.dart';
import 'colorforlistile.dart';

cardForListile(BuildContext context, Product item) {
  return Card(
    child: ListTile(
      title: Text(
        item.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: CircleAvatar(
        child: Text(
          item.name.substring(0, 1),
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        backgroundColor: colorforlistile(item),
      ),
      subtitle: Text(item.date.toIso8601String()),
      trailing: Text(item.quantity.toString()),
      onTap: () async {
        await dialogmenu(context, item);
      },
      onLongPress: () {
        showProductDetail(context, item);
      },
    ),
  );
}
