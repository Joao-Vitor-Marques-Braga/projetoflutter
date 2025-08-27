import 'package:flutter/material.dart';

class ProdutosScreen extends StatelessWidget {
  const ProdutosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final produtos = List.generate(20, (i) => 'Produto ${i + 1}');
    return Scaffold(
      appBar: AppBar(title: const Text('Cardápio')),
      body: ListView.separated(
        itemCount: produtos.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final nome = produtos[index];
          return ListTile(
            leading: const Icon(Icons.fastfood_rounded),
            title: Text(nome),
            subtitle: const Text('Clique para ver detalhes'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Navigator.of(context).pushNamed(
                '/produtos/detalhe',
                arguments: {
                  'id': index + 1,
                  'nome': nome,
                  'preco': 19.9 + index,
                },
              );
            },
          );
        },
      ),
    );
  }
}
