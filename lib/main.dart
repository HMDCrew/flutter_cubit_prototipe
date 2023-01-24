import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_skeleton_routed/logic/cubit/internet_cubit.dart';
import 'package:flutter_cubit_skeleton_routed/presentation/router/app_router.dart';

import 'logic/cubit/auth_cubit.dart';

void main() {
  runApp(Main(
    appRouter: AppRouter(),
    connectivity: Connectivity(),
  ));
}

class Main extends StatelessWidget {
  final AppRouter appRouter;
  final Connectivity connectivity;
  const Main({Key? key, required this.appRouter, required this.connectivity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetCubit>(
          create: (internetContext) =>
              InternetCubit(connectivity: connectivity),
        ),
        BlocProvider<AuthCubit>(
          create: (authContext) => AuthCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Skeleton routed',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF333333),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: appRouter.onGeneratedRoute,
        initialRoute: '/',
      ),
    );
  }
}
