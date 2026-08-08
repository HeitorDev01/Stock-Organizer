import 'dart:io';

import 'package:estoque_app/main.dart';
import 'package:estoque_app/models/produto.dart';
import 'package:estoque_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

/// Smoke tests da casca redesenhada.
///
/// O teste anterior era o contador padrão do template Flutter e nunca chegou a
/// corresponder a este app.
void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('stock_organizer_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProdutoAdapter());
    }
    await Hive.openBox<Produto>('produtos');
    await Hive.openBox('settings');
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await Hive.close();
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  Future<void> pumpApp(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MyApp(themeController: ThemeController(Hive.box('settings'))),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('estoque vazio mostra o estado inicial do painel',
      (WidgetTester tester) async {
    await pumpApp(tester, const Size(1400, 1000));

    expect(find.text('Seu estoque está vazio'), findsOneWidget);
  });

  testWidgets('largura de desktop renderiza a sidebar e não a barra inferior',
      (WidgetTester tester) async {
    await pumpApp(tester, const Size(1400, 1000));

    // Rótulos da sidebar expandida.
    expect(find.text('Painel'), findsWidgets);
    expect(find.text('Configurações'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('largura de celular troca a sidebar pela barra inferior',
      (WidgetTester tester) async {
    await pumpApp(tester, const Size(420, 900));

    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('produto abaixo do mínimo alimenta o painel',
      (WidgetTester tester) async {
    // `runAsync` é obrigatório: o corpo de `testWidgets` roda em FakeAsync e o
    // I/O real do Hive jamais completaria lá dentro.
    await tester.runAsync(() async {
      await Hive.box<Produto>('produtos').add(
        Produto(
          nome: 'Arroz',
          categoria: 'Alimentos',
          precoCusto: 10,
          precoVenda: 18,
          quantidade: 2,
          estoqueMinimo: 10,
          dataAdicao: DateTime.now(),
        ),
      );
    });

    await pumpApp(tester, const Size(1400, 1000));

    expect(find.text('Seu estoque está vazio'), findsNothing);
    // Lucro potencial = (18 - 10) * 2
    expect(find.text('R\$ 16,00'), findsOneWidget);
    expect(find.text('Itens em baixa'), findsOneWidget);
  });
}
