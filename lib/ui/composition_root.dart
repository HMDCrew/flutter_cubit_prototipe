import 'package:auth/auth.dart';
import 'package:custom_posts/custom_posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:products/products.dart';
import 'package:taxonomy/taxonomy.dart';

import '../cache/local_store.dart';
import '../states_management/products/product_cubit.dart' as product_cubit;
import '../states_management/taxonomy/taxonomy_cubit.dart' as taxonomy_cubit;
import '../states_management/banners/banners_cubit.dart' as banners_cubit;
import '../ui/pages/home/home.dart';
import 'pages/shop/shop.dart';
import 'utils/bottom_nav_bar.dart';

void printWrapped(String text) =>
    RegExp('.{1,800}').allMatches(text).map((m) => m.group(0)).forEach(print);

class CompositionRoot {
  static late SharedPreferences _sharedPreferences;
  static late LocalStore _localStore;
  static late String _baseUrl;
  static late Client _client;
  static late AuthApi authApi;
  static late ProductsApi productsApi;
  static late PostsApi bannersApi;
  static late TaxonomyApi taxonomyApi;

  static configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _localStore = LocalStore(_sharedPreferences);
    _baseUrl = "https://dev-panasonic.pantheonsite.io";
    _client = Client();
    authApi = AuthApi(_client, _baseUrl);
    productsApi = ProductsApi(_client, _baseUrl);
    bannersApi = PostsApi(_client, _baseUrl, 'banners');
    taxonomyApi = TaxonomyApi(_client, _baseUrl);

    // final test = await productsApi.findProducts(page: 0, pageSize: 10, searchTerm: 'Aparat');
    // printWrapped(test.asValue!.value.toString());
  }

  static Future<Widget> start({int myIndex = 0}) async {
    List<Widget> pagesAll = [
      composeHomeUi(),
      composeHomeUi(),
      composeShopUi(),
      composeHomeUi(),
      composeHomeUi(),
    ];

    List<IconData> pagesIcons = const <IconData>[
      Icons.home,
      Icons.favorite,
      Icons.local_mall,
      Icons.shopping_cart,
      Icons.person,
    ];

    //print(test[myIndex]);
    // Navigator.of(navKey.currentState!.context, rootNavigator: true).pop();

    // final token = await _localStore.fetch();
    // return token.isEmpty ? composeAuthUi() : composeHomeUi(token);
    //print(pagesAll[0]);
    
    return BottomNavBar(pagesAll, pagesIcons);
  }

  // static Widget composeAuthUi() {
  //   AuthCubit authCubit = AuthCubit(authApi, _localStore);
  //   // AuthPageAdapter adapter =
  //   //     AuthPageAdapter(onUserAuthenticated: composeHomeUi);

  //   return BlocProvider(
  //     create: (BuildContext context) => authCubit,
  //     child: AuthPage(authApi),
  //     //child: AuthPage(authApi, adapter),
  //   );
  // }

  static Widget composeHomeUi() {
    banners_cubit.BannerCubit bannerCubit = banners_cubit.BannerCubit(bannersApi);
    taxonomy_cubit.TaxonomyCubit taxonomyCubit = taxonomy_cubit.TaxonomyCubit(taxonomyApi);

    return MultiBlocProvider(providers: [
      BlocProvider<banners_cubit.BannerCubit>(
        create: (BuildContext context) => bannerCubit,
      ),
      BlocProvider<taxonomy_cubit.TaxonomyCubit>(
        create: (BuildContext context) => taxonomyCubit,
      ),
    ], child: Home());
  }

  static Widget composeShopUi() {
    product_cubit.ProductCubit productsCubit = product_cubit.ProductCubit(productsApi);

    return MultiBlocProvider(providers: [
      BlocProvider<product_cubit.ProductCubit>(
        create: (BuildContext context) => productsCubit,
      ),
    ], child: Shop());
  }

  // static Widget _composeSearchResultPageWith(String query) {
  //   RestaurantCubit restaurantCubit = RestaurantCubit(api, defaultPageSize: 10);
  //   ISearchResultsPageAdapter searchResultsPageAdapter =
  //       SearchResultsPageAdapter(onSelection: _composeRestaurantPageWith);
  //   return SearchResultPage(restaurantCubit, query, searchResultsPageAdapter);
  // }

  // static Widget _composeRestaurantPageWith(Restaurant? restaurant) {
  //   RestaurantCubit restaurantCubit = RestaurantCubit(api, defaultPageSize: 10);
  //   return RestaurantPage(restaurant, restaurantCubit);
  // }
}
