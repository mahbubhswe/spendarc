import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/injection.dart';
import 'features/transactions/presentation/home_page.dart';

const Color _appBackgroundColor = Colors.white;
const SystemUiOverlayStyle _systemUiStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  systemNavigationBarColor: _appBackgroundColor,
  systemNavigationBarIconBrightness: Brightness.dark,
  systemNavigationBarDividerColor: Colors.transparent,
  systemNavigationBarContrastEnforced: false,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );

  SystemChrome.setSystemUIOverlayStyle(_systemUiStyle);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _appBackgroundColor,
        appBarTheme: const AppBarTheme(systemOverlayStyle: _systemUiStyle),
      ),
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: _systemUiStyle,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: HomePage(),
    );
  }
}
