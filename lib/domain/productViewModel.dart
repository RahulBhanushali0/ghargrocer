import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:holmon/models/dto/product.dart';
import 'package:holmon/models/dto/product_page.dart';
import 'package:holmon/models/product_repo_Impl.dart';
import 'package:holmon/utils/myStates.dart';

import '../models/dto/categoryPage.dart';
import '../services/secure_storage_service.dart';

class ProductViewModel extends GetxController {
  ProductRepository _productRepository;
  ProductViewModel({required ProductRepository productRepositoryImpl})
      : _productRepository = productRepositoryImpl;
  final SecureStorageService _secureStorageService =
  SecureStorageService(); // Instantiate it

  Rx<MyState> _currentState = MyState().obs;
  MyState get currentState => _currentState.value;

  RxList<Product> _productList = <Product>[].obs;
  List<Product> get productList => _productList;

  RxInt page = 1.obs;
  RxInt lastPage = 1.obs;
  RxBool isFetchingMore = false.obs;

  Future<void> logout() async {
    await _secureStorageService.deleteApiToken();
    Get.offAllNamed('/registration');
  }

  Future<void> getAllProductList(int page) async {
    try {
      final ProductPage pageData =
          await _productRepository.getAllProductList(page: page);
      final productList = pageData.items;
      lastPage.value = pageData.lastPage;
      print("productList =>    ${productList}");
      _currentState.value = LoadingState();

      if (productList.isEmpty) {
        // Set state to EmptyDataState if the result is empty
        _currentState.value = FailureState('Data is empty');
      } else {
        // Update state to LoadedState with data
        _currentState.value = LoadedState(productList);
        _productList.value = productList;
      }
    } catch (e) {
      print('Error fetching data in viewModel: $e');
      // Update state to FailureState with error message
      _currentState.value = FailureState('An error occurred');
    }
  }

  Future<void> getAllCategoryList() async {
    try {
      final CategoryPage categoryData =
      await _productRepository.getAllCategoryList();
      print("categoryDatacategoryData ${categoryData.id}");
      // final productList = pageData.items;
      // lastPage.value = pageData.lastPage;
      // print("productList =>    ${productList}");
      // _currentState.value = LoadingState();

      // if (productList.isEmpty) {
      //   // Set state to EmptyDataState if the result is empty
      //   _currentState.value = FailureState('Data is empty');
      // } else {
      //   // Update state to LoadedState with data
      //   _currentState.value = LoadedState(productList);
      //   _productList.value = productList;
      // }
    } catch (e) {
      print('Error fetching data in viewModel: $e');
      // Update state to FailureState with error message
      _currentState.value = FailureState('An error occurred');
    }
  }

  Future<void> getProductById(String id) async {
    try {
      // Simulating data loading
      final product = await _productRepository.getProductByid(id: id);
      _currentState.value = LoadedState(product);
    } catch (e) {
      // Update state to FailureState with error message
      _currentState.value = FailureState('An error occurred');
    }
    return null;
  }

  late final ScrollController scrollController;
  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    //getAllProductList(page.value);
    scrollController.addListener(() async {
      if (!isFetchingMore.value &&
          scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          page.value < lastPage.value) {
        isFetchingMore.value = true;
        // Check if existing data is available
        if (_currentState.value is LoadedState) {
          // If data exists, append new items to the existing list
          List<Product> existingList =
              (_currentState.value as LoadedState).data;
          page.value += 1;

          final ProductPage pageData =
              await _productRepository.getAllProductList(page: page.value);
          lastPage.value = pageData.lastPage;
          final newList = pageData.items;

          final updatedList = existingList + newList;
          // Reassign the state so Obx listeners rebuild
          _currentState.value = LoadedState(updatedList.toList());
          _productList.value = updatedList;
          print("updated list length =>${updatedList.length}");
          isFetchingMore.value = false;
          return;
        }
      }
    });
  }

  @override
  void onClose() {
    _currentState.close();
    scrollController.dispose();
    super.onClose();
  }
}
