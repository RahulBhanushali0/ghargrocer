
import 'package:holmon/models/source/remote/api.dart';
import 'package:holmon/models/dto/product_page.dart';

import 'dto/categoryPage.dart';
import 'dto/products.dart';

class ProductRepositoryImpl implements ProductRepository {
  final Api _api;

  ProductRepositoryImpl({
    required Api api,
  }) : _api = api;

  @override
  Future<ProductPage> getAllProductList({required int page}) async {
    final fetched = await _api.loadProductList(page: page);
    return fetched;
  }

  @override
  Future<Product?> getProductByid({required String id}) async {
    final fetchedProduct = await _api.loadProductById(id: id);
    return fetchedProduct;
  }
}

abstract class ProductRepository {
  Future<ProductPage> getAllProductList({required int page});
  Future<Product?> getProductByid({required String id});
}
