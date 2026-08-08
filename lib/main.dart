import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/produto.dart';
import 'navigation/app_shell.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  Inicializa o Hive
  await Hive.initFlutter();

  //  Registra o adapter do Produto
  Hive.registerAdapter(ProdutoAdapter());

  // Abre a box
  await Hive.openBox<Produto>('produtos');

  await Hive.openBox('settings');

  runApp(MyApp(themeController: ThemeController(Hive.box('settings'))));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      controller: themeController,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeController,
        builder: (BuildContext context, ThemeMode mode, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Stock Organize',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: mode,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
