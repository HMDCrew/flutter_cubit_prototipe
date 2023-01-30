import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custom_posts/custom_posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_skeleton_routed/logic/cubit/internet_cubit.dart';
import 'package:flutter_cubit_skeleton_routed/presentation/router/app_router.dart';
import 'package:http/http.dart';
import 'package:products/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'logic/cache/local_store.dart';
import 'logic/cubit/auth_cubit.dart';
import 'logic/cubit/banners_cubit.dart';
import 'logic/cubit/product_cubit.dart';
import 'logic/cubit/shop_cubit.dart';

void main() async {
  // async main need next line
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client();
  String baseUrl = "https://dev-panasonic.pantheonsite.io";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String css = await rootBundle.loadString('assets/css/rich_content.css');
  String js = await rootBundle.loadString('assets/js/rich_content.js');

  runApp(
    Main(
      appRouter: AppRouter(),
      connectivity: Connectivity(),
      localStore: LocalStore(prefs),
      bannersApi: PostsApi(client, baseUrl, 'banners'),
      productsApi: ProductsApi(client, baseUrl),
      css: css,
      js: js,
    ),
  );
}

class Main extends StatelessWidget {
  final AppRouter appRouter;
  final Connectivity connectivity;
  final LocalStore localStore;
  final PostsApi bannersApi;
  final ProductsApi productsApi;

  final String css;
  final String js; 
  const Main({
    Key? key,
    required this.appRouter,
    required this.connectivity,
    required this.localStore,
    required this.bannersApi,
    required this.productsApi,
    required this.css,
    required this.js,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetCubit>(
          create: (internetContext) =>
              InternetCubit(connectivity: connectivity),
        ),
        BlocProvider<AuthCubit>(
          create: (BuildContext authContext) => AuthCubit(),
        ),
        BlocProvider(
          create: (BuildContext bannersContext) => BannersCubit(bannersApi, localStore),
        ),
        BlocProvider<ShopCubit>(
          create: (BuildContext shopContext) => ShopCubit(productsApi, localStore),
        ),
        BlocProvider<ProductCubit>(
          create: (BuildContext shopContext) => ProductCubit(productsApi, localStore, css, js),
        ),
      ],
      child: MaterialApp(
        title: 'Skeleton routed',
        theme: ThemeData(
          primarySwatch: Colors.grey,
          scaffoldBackgroundColor: const Color(0xFF333333),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: appRouter.onGeneratedRoute,
        initialRoute: '/shop',
      ),
    );
  }
}
