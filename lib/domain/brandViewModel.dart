import 'package:get/get.dart';
import 'package:holmon/models/dto/brandList.dart';
import 'package:holmon/utils/myStates.dart';
import 'package:holmon/models/product_repo_Impl.dart';

class BrandViewModel extends GetxController {
  final ProductRepository _productRepository;
  BrandViewModel({required ProductRepository productRepositoryImpl})
      : _productRepository = productRepositoryImpl;

  Rx<MyState> _currentState = MyState().obs;
  MyState get currentState => _currentState.value;

  RxList<Brand> _brandList = <Brand>[].obs;
  List<Brand> get brandList => _brandList;

  RxInt page = 1.obs;
  RxInt lastPage = 1.obs;
  RxBool isFetchingMore = false.obs;

  Future<void> getAllBrandList(int page) async {
    try {
      _currentState.value = LoadingState();
      final BrandList brandListData =
          await _productRepository.getAllBrandList(page: page);
      final brands = brandListData.data?.data ?? [];
      lastPage.value = brandListData.data?.lastPage ?? 1;
      if (brands.isEmpty) {
        _currentState.value = FailureState('No brands found');
      } else {
        _currentState.value = LoadedState(brands);
        _brandList.value = brands;
      }
    } catch (e) {
      _currentState.value = FailureState('An error occurred');
    }
  }
}
