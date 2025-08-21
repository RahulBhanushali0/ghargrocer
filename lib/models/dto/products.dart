// To parse this JSON data, do
//
//     final categoryList = categoryListFromJson(jsonString);

import 'dart:convert';

ProductList ProductListFromJson(String str) => ProductList.fromJson(json.decode(str));

String ProductListToJson(ProductList data) => json.encode(data.toJson());

class ProductList {
  bool? success;
  String? message;
  Data? data;

  ProductList({
    this.success,
    this.message,
    this.data,
  });

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? currentPage;
  List<Product>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<Product>.from(json["data"]!.map((x) => Product.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null ? [] : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Product {
  String? id;
  String? name;
  String? slug;
  int? qty;
  String? unit;
  String? unitValue;
  String? price;
  String? oldPrice;
  List<Images>? images;
  bool? featured;
  List<dynamic>? productDiscounts;
  bool? backorder;
  DateTime? publishedAt;
  String? description;
  String? brandId;
  Brand? brand;
  List<Category>? categories;

  Product({
    this.id,
    this.name,
    this.slug,
    this.qty,
    this.unit,
    this.unitValue,
    this.price,
    this.oldPrice,
    this.images,
    this.featured,
    this.productDiscounts,
    this.backorder,
    this.publishedAt,
    this.description,
    this.brandId,
    this.brand,
    this.categories,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    qty: json["qty"],
    unit: json["unit"],
    unitValue: json["unit_value"],
    price: json["price"],
    oldPrice: json["old_price"],
    images: json["images"] == null ? [] : List<Images>.from(json["images"]!.map((x) => Images.fromJson(x))),
    featured: json["featured"],
    productDiscounts: json["product_discounts"] == null ? [] : List<dynamic>.from(json["product_discounts"]!.map((x) => x)),
    backorder: json["backorder"],
    publishedAt: json["published_at"] == null ? null : DateTime.parse(json["published_at"]),
    description: json["description"],
    brandId: json["brand_id"],
    brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
    categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "qty": qty,
    "unit": unit,
    "unit_value": unitValue,
    "price": price,
    "old_price": oldPrice,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
    "featured": featured,
    "product_discounts": productDiscounts == null ? [] : List<dynamic>.from(productDiscounts!.map((x) => x)),
    "backorder": backorder,
    "published_at": "${publishedAt!.year.toString().padLeft(4, '0')}-${publishedAt!.month.toString().padLeft(2, '0')}-${publishedAt!.day.toString().padLeft(2, '0')}",
    "description": description,
    "brand_id": brandId,
    "brand": brand?.toJson(),
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
  };
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product.fromJson(map);
  }
  factory Product.fromRawJson(String str) {
    return Product.fromJson(json.decode(str));
  }
  String toRawJson() {
    return json.encode(this.toJson());
  }

}

class Brand {
  String? id;
  String? name;
  dynamic image;
  String? website;
  String? description;

  Brand({
    this.id,
    this.name,
    this.image,
    this.website,
    this.description,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    website: json["website"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "website": website,
    "description": description,
  };
}

class Category {
  String? id;
  String? name;
  String? description;

  Category({
    this.id,
    this.name,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}

class Images {
  String? image;

  Images({
    this.image,
  });

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
  };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}
