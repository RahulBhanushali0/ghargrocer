import 'package:dio/dio.dart';
import 'package:holmon/models/dto/product.dart';
import 'package:holmon/models/dto/product_page.dart';

import '../../../constants/appConstants.dart';
import '../../dto/categoryPage.dart';

abstract class Api {
  //interface is depend on your api endpoints, your needs...etc
  Api(String appBaseUrl);
  Future<ProductPage> loadProductList({required int page});
  Future<Product> loadProductById({required String id});
  Future<CategoryPage> loadCategoryList();
}

//Implemntaion depend on your api documentaion
class ApiImpl implements Api {
  final Dio dio;
  final String appBaseUrl;


  ApiImpl(this.appBaseUrl) : dio = Dio(BaseOptions(baseUrl: appBaseUrl));

  @override
  Future<ProductPage> loadProductList({required int page}) async {
    try {
      Response response;
      dio.options.headers.addAll({
        'Authorization': AppConstants.authToken,
      });
      // Backend returns Laravel-style pagination at /product
      response = await dio.get(
        appBaseUrl + AppConstants.fetchAllProdList,
        queryParameters: {
          'page': page,
          'per_page': 10,
        },
      );
      print("responseresponse =>>>>${response}");

      dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));

      // New response structure: { success, message, data: { data: [ ...products ] , ... } }
      final dynamic root = response.data;
      final dynamic dataNode = root is Map ? root['data'] : null;
      final List<dynamic> listNode =
          (dataNode is Map && dataNode['data'] is List) ? dataNode['data'] as List : <dynamic>[];

      final l = listNode
          .map((e) => Product.fromMap(e as Map<String, dynamic>))
          .where((element) => element.productname != null && element.id != null)
          .toList();
      print("api return " + l.toString());
      final int currentPage = (dataNode is Map && dataNode['current_page'] is int)
          ? dataNode['current_page'] as int
          : page;
      final int lastPage = (dataNode is Map && dataNode['last_page'] is int)
          ? dataNode['last_page'] as int
          : page;
      final int? from = (dataNode is Map && dataNode['from'] is int)
          ? dataNode['from'] as int
          : null;
      final int? to = (dataNode is Map && dataNode['to'] is int)
          ? dataNode['to'] as int
          : null;
      final int? total = (dataNode is Map && dataNode['total'] is int)
          ? dataNode['total'] as int
          : null;
      return ProductPage(
        items: l,
        currentPage: currentPage,
        lastPage: lastPage,
        from: from,
        to: to,
        total: total,
      );
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);

        //  API responds with 404 when reached the end
        if (e.response?.statusCode == 404) {
          return ProductPage(items: [], currentPage: page, lastPage: page);
        }
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }

    return ProductPage(items: [], currentPage: page, lastPage: page);
  }

  @override
  Future<Product> loadProductById({required String id}) async {
    try {
      Response response;
      response = await dio.get(appBaseUrl + AppConstants.fetchAllProdList + '/$id');

      print('asdahjsdhkashdkashdh${response}',);

      final dynamic root = response.data;
      // If API returns the product directly
      if (root is Map && root['id'] != null) {
        return Product.fromMap(root.cast<String, dynamic>());
      }
      // Or wrapped inside { data: {...} }
      if (root is Map && root['data'] is Map) {
        return Product.fromMap((root['data'] as Map).cast<String, dynamic>());
      }
      // Fallback
      throw Exception('Unexpected product by id response');
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);

        //  API responds with 404 when reached the end
        //if (e.response?.statusCode == 404) return l;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }
    throw UnimplementedError();
  }


  @override
  Future<CategoryPage> loadCategoryList() async {
    try {
      Response response;
      dio.options.headers.addAll({
        'Authorization': AppConstants.authToken,
      });
      // Backend returns Laravel-style pagination at /product
      response = await dio.get(
        appBaseUrl + AppConstants.fetchAllCategoryList,
        // queryParameters: {
        //   'page': page,
        //   'per_page': 10,
        // },
      );
      print("fetchAllCategoryList =>>>>${response}");

      dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));

      final dynamic root = response.data;
      final dynamic dataNode = root is Map ? root['data'] : null;
      final List<dynamic> listNode =
      (dataNode is Map && dataNode['data'] is List) ? dataNode['data'] as List : <dynamic>[];

      final l = listNode
          .map((e) => Product.fromMap(e as Map<String, dynamic>))
          .where((element) => element.productname != null && element.id != null)
          .toList();
      print("api return " + l.toString());
      return CategoryPage(
        items: l,
        website: "website",
        id: "id",
        name: "name",
        slug: "slug",
        image: "image",
        description: "description",
      );
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);

        //  API responds with 404 when reached the end
        if (e.response?.statusCode == 404) {
          return CategoryPage(items: []);
        }
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }

    return CategoryPage(items: []);
  }



}
