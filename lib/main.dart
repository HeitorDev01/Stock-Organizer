import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/produto.dart';
import 'pages/main_menu_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  //  Inicializa o Hive
  await Hive.initFlutter();

  //  Registra o adapter do Produto
  Hive.registerAdapter(ProdutoAdapter());

  // Abre a box
  await Hive.openBox<Produto>('produtos');

  await Hive.openBox('settings');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Organize',
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(), // Ou sua customizada
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainMenuPage(),
    );
  }
}
