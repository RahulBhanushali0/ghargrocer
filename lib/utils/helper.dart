import 'package:get/get.dart';
import 'package:holmon/domain/cartViewModel.dart';
import 'package:holmon/domain/categorieViewModel.dart';
import 'package:holmon/domain/productViewModel.dart';
import 'package:holmon/models/product_repo_Impl.dart';
import 'package:holmon/models/shopingCart_repo_impl.dart';
import 'package:holmon/models/source/local/cart_local_storage.dart';
import 'package:holmon/models/source/remote/api.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:holmon/constants/appConstants.dart';

Future initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => ApiImpl(AppConstants.BASE_URL), fenix: true);

  Get.lazyPut(() => ProductRepositoryImpl(
        api: Get.find<ApiImpl>(),
      ), fenix: true);

  Get.lazyPut(
      () => ProductViewModel(
          productRepositoryImpl: Get.find<ProductRepositoryImpl>()),
      fenix: true);

  Get.lazyPut(() => CartLocalStorageImpl(sharedPreferences: sharedPreferences),
      fenix: true);

  Get.lazyPut(() => CartRepositoryImpl(
        cartLocalStorage: Get.find<CartLocalStorageImpl>(),
      ), fenix: true);

  // Eagerly instantiate ShoppingCartViewModel and keep it permanent
  Get.put(ShoppingCartViewModel(
      cartRepositoryImpl: Get.find<CartRepositoryImpl>()),
      permanent: true);

  Get.put(CategorieViewModel());

  //Get.put(SearchViewModel());

  //Get.put(MyGameController());
}

Future<LottieComposition?> customDecoder(List<int> bytes) {
  return LottieComposition.decodeZip(bytes, filePicker: (files) {
    return files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'));
  });
}
