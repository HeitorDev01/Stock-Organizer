// import 'package:flutter/material.dart';
// import 'models/produto.dart';

// void main() {
//   runApp(const MyApp());
// }

// // ================== APP ==================
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Stock Organize',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// // ================== HOME PAGE ==================
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// // ================== STATE ==================
// class _HomePageState extends State<HomePage> {
//   List<Produto> produtos = [];

//   void mostrarFormulario({Produto? produto, int? index}) {
//   final nomeController =
//       TextEditingController(text: produto?.nome ?? '');
//   final categoriaController =
//       TextEditingController(text: produto?.categoria ?? '');
//   final precoCustoController =
//       TextEditingController(text: produto?.precoCusto.toString() ?? '');
//   final precoVendaController =
//       TextEditingController(text: produto?.precoVenda.toString() ?? '');
//   final quantidadeController =
//       TextEditingController(text: produto?.quantidade.toString() ?? '');
//   final estoqueMinimoController =
//       TextEditingController(text: produto?.estoqueMinimo.toString() ?? '');

//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text(produto == null ? 'Novo Produto' : 'Editar Produto'),
//         content: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(
//                 controller: nomeController,
//                 decoration: const InputDecoration(labelText: 'Nome'),
//               ),
//               TextField(
//                 controller: categoriaController,
//                 decoration: const InputDecoration(labelText: 'Categoria'),
//               ),
//               TextField(
//                 controller: precoCustoController,
//                 decoration:
//                     const InputDecoration(labelText: 'Preço de custo'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: precoVendaController,
//                 decoration:
//                     const InputDecoration(labelText: 'Preço de venda'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: quantidadeController,
//                 decoration:
//                     const InputDecoration(labelText: 'Quantidade'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: estoqueMinimoController,
//                 decoration:
//                     const InputDecoration(labelText: 'Estoque mínimo'),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancelar'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final novoProduto = Produto(
//                 nome: nomeController.text,
//                 categoria: categoriaController.text,
//                 precoCusto:
//                     double.tryParse(precoCustoController.text) ?? 0,
//                 precoVenda:
//                     double.tryParse(precoVendaController.text) ?? 0,
//                 quantidade:
//                     int.tryParse(quantidadeController.text) ?? 0,
//                 estoqueMinimo:
//                     int.tryParse(estoqueMinimoController.text) ?? 0,
//               );

//               setState(() {
//                 if (produto == null) {
//                   //  NOVO
//                   produtos.add(novoProduto);
//                 } else {
//                   //  EDITAR
//                   produtos[index!] = novoProduto;
//                 }
//               });

//               Navigator.pop(context);
//             },
//             child: const Text('Salvar'),
//           ),
//         ],
//       );
//     },
//   );
// }
// }