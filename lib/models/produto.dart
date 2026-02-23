import 'package:hive/hive.dart';

part 'produto.g.dart';

@HiveType(typeId: 0)
class Produto extends HiveObject {
  
  @HiveField(0)
  String nome;

  @HiveField(1)
  String categoria; // Removi o 'final'

  @HiveField(2)
  double precoCusto; // Removi o 'final'

  @HiveField(3)
  double precoVenda; // Removi o 'final'

  @HiveField(4)
  int quantidade; // Removi o 'final'

  @HiveField(5)
  int estoqueMinimo; // Removi o 'final'

  @HiveField(6) 
  DateTime dataAdicao;

  Produto({
    required this.nome,
    required this.categoria,
    required this.precoCusto,
    required this.precoVenda,
    required this.quantidade,
    this.estoqueMinimo = 50,
    required this.dataAdicao,
  });

  // Getters continuam funcionando normalmente
  bool get estoqueBaixo => quantidade <= estoqueMinimo;
  double get lucroUnitario => precoVenda - precoCusto;
  double get lucroTotalEstimado => lucroUnitario * quantidade;
}