
import 'package:holmon/models/dto/products.dart';

class CategoryPage {
  List<Product>? items;
  String? website;
  String? id;
  String? name;
  String? slug;
  dynamic image;
  String? description;

  CategoryPage({
    this.items,
    this.website,
    this.id,
    this.name,
    this.slug,
    this.image,
    this.description,
  });
}


class CategoryPageList {
  List<CategoryPage>? items;


  CategoryPageList({
    this.items,
  });
}

