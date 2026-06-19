import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mortgage_provider.dart';
import 'main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final mortgageProvider = MortgageProvider();
  await mortgageProvider.loadFromPrefs();

  runApp(
    ChangeNotifierProvider.value(
      value: mortgageProvider,
      child: const MortgageApp(),
    ),
  );
}

class MortgageApp extends StatelessWidget {
  const MortgageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MortgageV0',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainScreen(),
    );
  }
}