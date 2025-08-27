import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery - Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.delivery_dining_rounded, size: 72),
            SizedBox(height: 12),
            Text('Bem-vindo ao app de Delivery!'),
          ],
        ),
      ),
    );
  }
}
