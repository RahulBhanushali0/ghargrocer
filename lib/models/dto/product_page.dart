import 'package:holmon/models/dto/product.dart';

class ProductPage {
  final List<Product> items;
  final int currentPage;
  final int lastPage;
  final int? from;
  final int? to;
  final int? total;

  ProductPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    this.from,
    this.to,
    this.total,
  });
}


