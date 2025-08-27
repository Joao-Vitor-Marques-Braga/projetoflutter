import 'package:flutter/material.dart';

class PedidosScreen extends StatelessWidget {
  const PedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pedidos = List.generate(5, (i) => 'Pedido #${1000 + i}');
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Pedidos')),
      body: ListView.separated(
        itemCount: pedidos.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final p = pedidos[index];
          return ListTile(
            leading: const Icon(Icons.receipt_long_rounded),
            title: Text(p),
            subtitle: const Text('Status: entregue'),
          );
        },
      ),
    );
  }
}
