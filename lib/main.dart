import 'package:flutter/material.dart';

import 'ui/composition_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  final screenToShow = await CompositionRoot.start();
  runApp(MyApp(screenToShow));
}

class MyApp extends StatelessWidget {
  final Widget startPage;
  const MyApp(this.startPage, {super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
        //textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFF333333));

    return MaterialApp(
      title: 'Flutter Skeleton',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme
            .copyWith(secondary: const Color.fromARGB(255, 251, 176, 59)),
      ),
      home: SafeArea(child: startPage),
    );
  }
}
