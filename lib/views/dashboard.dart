import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holmon/constants/assets.dart';
import 'package:holmon/domain/productViewModel.dart';
import 'package:holmon/utils/myTheme.dart';
import 'package:holmon/views/common_widgets/appBar.dart';
import 'package:holmon/views/common_widgets/dropDownHomeMenu.dart';
import '../domain/categorieViewModel.dart';
import '../models/dto/categoryPage.dart';
import '../utils/myStates.dart';
import 'common_widgets/carousel.dart';
import 'package:get/get.dart';
import 'common_widgets/categories_view.dart';
import 'common_widgets/horizontal_product_list.dart';
import 'common_widgets/see_all_view.dart';
import 'common_widgets/vegetable_card.dart';
import '../domain/brandViewModel.dart';
import '../models/dto/brandList.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin {
  final ProductViewModel productViewModel = Get.find<ProductViewModel>();
  final CategorieViewModel categorieViewModel = Get.find<CategorieViewModel>();
  final BrandViewModel brandViewModel = Get.find<BrandViewModel>();
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    categorieViewModel.getAllCategoryList(1);
    brandViewModel.getAllBrandList(1);
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: MyAppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
            child: DropDownMenu(),
          ),
          leadingWidth: MediaQuery.of(context).size.width * 2 / 4,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 12,
                ),
                Icon(
                  Icons.delivery_dining,
                  color: Colors.redAccent,
                ),
                SizedBox(
                  width: 4,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Free delivery',
                      style: TextStyle(
                          color: Get.theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          letterSpacing: 0),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '2000da +',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ThemeSwitcher(
                clipper: ThemeSwitcherCircleClipper(),
                builder: (context) {
                  return InkResponse(
                    onTap: () => {
                      ThemeSwitcher.of(context).changeTheme(
                          theme: Get.isDarkMode
                              ? AppThemes.lightTheme1
                              : AppThemes.darkTheme2,
                          isReversed: Get.isDarkMode ? false : true)
                    },
                    // onTap: () => {
                    //   productViewModel.logout(),
                    // },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CircleAvatar(
                        child: Image.asset(
                          Assets.imagesUser,
                          scale: 4,
                        ),
                      ),
                    ),
                  );
                }),
          ]),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  readOnly: true,
                  onTap: () => Get.toNamed('/search'),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Color.fromARGB(255, 219, 219, 219)),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "What are u looking for ?",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: Get.theme.colorScheme.primary,
                          fontWeight: FontWeight.w500),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: Color(0xff2382AA),
                      ),
                      suffixIcon: InkWell(
                        onTap: () => Get.toNamed("/ArExperience"),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                          child: Icon(
                            CupertinoIcons.camera,
                            color: Color.fromARGB(255, 193, 193, 193),
                          ),
                        ),
                      )))),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Carousel()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Obx(() {
              final state = brandViewModel.currentState;
              if (state is LoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is LoadedState) {
                final List<Brand> brands = state.data;
                if (brands.isEmpty) {
                  return Center(child: Text('No brands found'));
                }
                return SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: brands.length,
                    itemBuilder: (context, index) {
                      final brand = brands[index];
                      return InkWell(
                        onTap: (){

                        },
                        child: Container(
                          width: 90,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: brand.image != null && brand.image!.isNotEmpty
                                    ? Image.network(
                                        // brand.image!,
                                  "https://ghargrocer.com/storage/${brand.image!}",
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.image, size: 30),
                                      ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 50,
                                child: Text(
                                  brand.name ?? '',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is FailureState) {
                return Center(child: Text(state.error));
              } else {
                return SizedBox.shrink();
              }
            }),
          ),
          Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SeeAllView(
                    context: context,
                    name: "Categories 🛍️",
                    onTapAction: () => Get.toNamed("/dashboard", arguments: 1)),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CategoriesView(
                            imagePath: Assets.imagesFish,
                            catName: "Seafood",
                            context: context),
                        CategoriesView(
                            imagePath: Assets.imagesFalafel,
                            catName: "Vegetables",
                            context: context),
                        CategoriesView(
                            imagePath: Assets.imagesBanana,
                            catName: "Fruits",
                            context: context),
                        CategoriesView(
                            imagePath: Assets.imagesIceCream,
                            catName: "Snacks",
                            context: context),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        CategoriesView(
                            imagePath: Assets.imagesDish,
                            catName: "Canned food",
                            context: context),
                        CategoriesView(
                            imagePath: Assets.imagesRice,
                            catName: "Pasta, Rice",
                            context: context),
                        CategoriesView(
                            imagePath: Assets.imagesSavon,
                            catName: "Home Supplie",
                            context: context),
                        CategoriesView(
                            imagePath: Assets.imagesMakeup,
                            catName: "Woman care",
                            context: context),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Obx(() =>
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SeeAllView(
                    context: context,
                    name: "Best deals 🔥${productViewModel.productList.length}",
                    onTapAction: () => Get.toNamed("/vegetables")),
              ),),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                    height: 210,
                    //padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: HorizontalProductList(
                      page: 1,
                      isSecondList: false,
                    )),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
          Obx(() {
            final state = categorieViewModel.currentState;
            if (state is LoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is LoadedState) {
              // List<Datum> from categoryPage.dart
              final List<Datum> categories = state.data;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categories.map((category) {
                    if (category.products == null || category.products!.isEmpty) {
                      return SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            category.name ?? '',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 220,

                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: category.products!.length,
                            itemBuilder: (context, index) {
                              final product = category.products![index];
                              return Row(children: [
                                VegetableCardWidget(product: product),
                                SizedBox(
                                  width: 8,
                                )
                              ],);
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            } else if (state is FailureState) {
              return Center(child: Text(state.error));
            } else {
              return SizedBox.shrink();
            }
          }),
        ]),
      ),
    );
  }
}
