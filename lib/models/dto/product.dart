/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
import 'dart:convert';
import 'dart:math';

class Product {
  String? categories;
  String? id;
  String? imagefrontsmallurl;
  String? imagefronturl;
  String? imagenutritionurl;
  String? manufacturingplaces;
  String? productname;
  String? quantity;
  String? stores;
  final String? price;
  final String? regularPrice;
  final String? discount;
  final int? qty;

  Product(
      {this.categories,
      this.id,
      this.imagefrontsmallurl,
      this.imagefronturl,
      this.imagenutritionurl,
      this.manufacturingplaces,
      this.productname,
      this.quantity,
      this.stores,
      this.price,
      this.regularPrice,
      this.discount,
      this.qty});

  // ---------------------------------------------------------------------------
  // JSON
  // ---------------------------------------------------------------------------
  factory Product.fromRawJson(String str) => Product.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------

  factory Product.fromMap(Map<String, dynamic> json) {
    // Back-end now returns Laravel-style pagination with product fields:
    // id, name, slug, qty, unit, unit_value, price, old_price, images, ... , categories: List<{ name, ... }>
    final String? id = json['id']?.toString();
    final String? name = json['name']?.toString();
    final String? unit = json['unit']?.toString();
    final String? unitValue = json['unit_value']?.toString();
    final String? price = json['price']?.toString();
    final String? oldPrice = json['old_price']?.toString();
    final int? qty = () {
      final dynamic q = json['qty'];
      if (q is int) return q;
      if (q is String) return int.tryParse(q);
      return null;
    }();

    // Compose quantity as "<unit_value> <unit>", e.g., "20.00 kg"
    final String? composedQuantity = unitValue != null && unit != null
        ? "$unitValue $unit"
        : json['quantity']?.toString();

    // Compose categories as comma-separated names
    String? categories;
    if (json['categories'] is List) {
      try {
        final List list = json['categories'] as List;
        final names = list
            .map((e) => (e is Map && e['name'] != null) ? e['name'].toString() : null)
            .whereType<String>()
            .toList();
        if (names.isNotEmpty) {
          categories = names.join(', ');
        }
      } catch (_) {}
    } else if (json['categories'] is String) {
      categories = json['categories'];
    }

    // Derive discount if old_price and price exist
    String? discount;
    if (price != null && oldPrice != null) {
      try {
        final double p = double.tryParse(price) ?? 0;
        final double op = double.tryParse(oldPrice) ?? 0;
        if (op > 0 && p >= 0 && p <= op) {
          final percent = ((op - p) / op * 100).round();
          discount = "$percent%";
        }
      } catch (_) {}
    }

    // Try extracting image URL(s)
    String? primaryImageUrl;
    if (json['images'] is List) {
      try {
        final List images = json['images'] as List;
        for (final dynamic item in images) {
          if (item is String && item.isNotEmpty) {
            primaryImageUrl = item;
            break;
          }
          if (item is Map) {
            final dynamic url = item['url'] ?? item['image'] ?? item['path'];
            if (url != null && url.toString().isNotEmpty) {
              primaryImageUrl = url.toString();
              break;
            }
          }
        }
      } catch (_) {}
    }

    return Product(
      categories: categories,
      id: id,
      imagefrontsmallurl: json['image_front_small_url'] ?? primaryImageUrl,
      imagefronturl: json['image_front_url'] ?? primaryImageUrl,
      imagenutritionurl: json['image_nutrition_url'],
      manufacturingplaces: json['manufacturing_places'],
      productname: name ?? json['product_name'],
      quantity: composedQuantity,
      stores: json['stores'],
      price: price ??
          (Random().nextDouble() * (100 - 5) + 5).toStringAsFixed(2),
      regularPrice: oldPrice ??
          (Random().nextDouble() * (150 - 40) + 40).toStringAsFixed(2),
      discount: discount ?? (Random().nextInt(51) + 10).toString() + "%",
      qty: qty,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['categories'] = categories;
    data['id'] = id;
    data['image_front_small_url'] = imagefrontsmallurl;
    data['image_front_url'] = imagefronturl;
    data['image_nutrition_url'] = imagenutritionurl;
    data['manufacturing_places'] = manufacturingplaces;
    data['product_name'] = productname;
    data['quantity'] = quantity;
    data['stores'] = stores;
    data['price'] = price ??
        (Random().nextDouble() * (100 - 5) + 5).toStringAsFixed(2) + "₹";
    data['regularPrice'] = regularPrice ??
        (Random().nextDouble() * (150 - 40) + 40).toStringAsFixed(2) + "₹";
    data['discount'] = discount ?? (Random().nextInt(51) + 10).toString() + "%";
    data['qty'] = qty;
    return data;
  }
}
