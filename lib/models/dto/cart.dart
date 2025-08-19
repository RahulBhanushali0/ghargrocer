import 'dart:convert';

import 'package:holmon/models/dto/products.dart';

class CartItem extends Product {
  int itemQuantity;
  CartItem({
    required String? id,
    required String? name,
    required String? price,
    required List<Images>? images,
    int? qty,
    required this.itemQuantity,
  }) : super(
    id: id,
    name: name,
    price: price,
    qty: qty,
    images: images,
  );

  // ---------------------------------------------------------------------------
  // JSON
  // ---------------------------------------------------------------------------

  factory CartItem.fromRawJson(String str) =>
      CartItem.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------

  factory CartItem.fromMap(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      itemQuantity: json['itemQuantity'],
      qty: json['qty'],
      images: json['images'] == null
          ? []
          : List<Images>.from(
          (json['images'] as List).map((x) => Images.fromJson(x))),
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['qty'] = qty;
    data['itemQuantity'] = itemQuantity;
    data['images'] = images == null
        ? []
        : List<dynamic>.from(images!.map((x) => x.toJson()));
    return data;
  }
}