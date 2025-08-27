import 'package:flutter/material.dart';

class ProdutoDetalheScreen extends StatelessWidget {
  final Map<String, dynamic>? dados;

  const ProdutoDetalheScreen({super.key, this.dados});

  @override
  Widget build(BuildContext context) {
    final info = dados ?? const {'nome': 'Produto', 'preco': 0.0, 'id': 0};
    return Scaffold(
      appBar: AppBar(title: Text('${info['nome']}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${info['id']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Preço: R\$ ${info['preco']}',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.add_shopping_cart_rounded),
                label: const Text('Adicionar e voltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
