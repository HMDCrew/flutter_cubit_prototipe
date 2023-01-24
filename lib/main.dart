import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custom_posts/custom_posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_skeleton_routed/logic/cubit/internet_cubit.dart';
import 'package:flutter_cubit_skeleton_routed/presentation/router/app_router.dart';
import 'package:http/http.dart';
import 'package:products/products.dart';

import 'logic/cubit/auth_cubit.dart';
import 'logic/cubit/banners_cubit.dart';
import 'logic/cubit/shop_cubit.dart';

void main() {
  Client client = Client();
  String baseUrl = "https://dev-panasonic.pantheonsite.io";

  runApp(
    Main(
      appRouter: AppRouter(),
      connectivity: Connectivity(),
      bannersApi: PostsApi(client, baseUrl, 'banners'),
      productsApi: ProductsApi(client, baseUrl),
    ),
  );
}

class Main extends StatelessWidget {
  final AppRouter appRouter;
  final Connectivity connectivity;
  final PostsApi bannersApi;
  final ProductsApi productsApi;
  const Main({
    Key? key,
    required this.appRouter,
    required this.connectivity,
    required this.bannersApi,
    required this.productsApi,
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
          create: (BuildContext bannersContext) => BannersCubit(bannersApi),
        ),
        BlocProvider<ShopCubit>(
          create: (BuildContext shopContext) => ShopCubit(productsApi),
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
        initialRoute: '/',
      ),
    );
  }
}
