

import 'package:holmon/models/source/remote/api.dart';
import 'dto/product_page.dart';
import 'dto/products.dart';
import 'dto/categoryPage.dart';
import 'dto/brandList.dart';


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
  Future<CategoryList> getAllCategoryList({required int page}) async {
    final fetched = await _api.loadCategoryList(page: page);
    return fetched as CategoryList;
  }

  @override
  Future<Product?> getProductByid({required String id}) async {
    final fetchedProduct = await _api.loadProductById(id: id);
    return fetchedProduct;
  }

  @override
  Future<BrandList> getAllBrandList({required int page}) async {
    final fetched = await _api.loadBrandList(page: page);
    return fetched;
  }
}

abstract class ProductRepository {
  Future<ProductPage> getAllProductList({required int page});
  Future<CategoryList> getAllCategoryList({required int page});
  Future<Product?> getProductByid({required String id});
  Future<BrandList> getAllBrandList({required int page});
}
