import 'package:flutter/material.dart';
import 'package:warehouse/model/produt.dart';

colorforlistile(Product product) {
  if (product.quantity < product.minQuantity) {
    return Colors.red;
  } else {
    return Colors.blue;
  }
}
