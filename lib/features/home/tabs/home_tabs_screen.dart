import 'package:flutter/material.dart';
import 'package:projetoflutter/features/home/pages/home_screen.dart';
import 'package:projetoflutter/features/produtos/pages/produtos_screen.dart';
import 'package:projetoflutter/features/produtos/pages/produto_detalhe_screen.dart';
import 'package:projetoflutter/features/pedidos/pages/pedidos_screen.dart';
import 'package:projetoflutter/core/navigation/tab_state.dart';

/// Abas do app com Navigators aninhados por aba
class HomeTabsScreen extends StatefulWidget {
  const HomeTabsScreen({super.key});

  @override
  State<HomeTabsScreen> createState() => _HomeTabsScreenState();
}

class _HomeTabsScreenState extends State<HomeTabsScreen> {
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onTap(int index) {
    selectedTabIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: selectedTabIndex,
        builder: (context, currentIndex, _) {
          return IndexedStack(
            index: currentIndex,
            children: [
              _buildTabNavigator(0, _routesHome),
              _buildTabNavigator(1, _routesProdutos),
              _buildTabNavigator(2, _routesPedidos),
            ],
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: selectedTabIndex,
        builder: (context, currentIndex, __) => BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_rounded),
              label: 'Cardápio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded),
              label: 'Pedidos',
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Nested Navigators per tab ----------

  Widget _buildTabNavigator(int tabIndex, RouteFactory onGenerateRoute) {
    return Navigator(
      key: _navigatorKeys[tabIndex],
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }

  Route<dynamic> _routeWrapper(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

  // ---------- Rotas por aba ----------

  Route<dynamic>? _routesHome(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/home':
        return _routeWrapper(const HomeScreen());
      default:
        return _routeWrapper(_notFound(settings.name));
    }
  }

  Route<dynamic>? _routesProdutos(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/produtos':
        return _routeWrapper(const ProdutosScreen());
      case '/produtos/detalhe':
        final args = settings.arguments;
        final Map<String, dynamic>? dados = args is Map<String, dynamic>
            ? args
            : null;
        return _routeWrapper(ProdutoDetalheScreen(dados: dados));
      default:
        return _routeWrapper(_notFound(settings.name));
    }
  }

  Route<dynamic>? _routesPedidos(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/pedidos':
        return _routeWrapper(const PedidosScreen());
      default:
        return _routeWrapper(_notFound(settings.name));
    }
  }

  Widget _notFound(String? name) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rota não encontrada')),
      body: Center(child: Text('A rota "$name" não existe nesta aba.')),
    );
  }
}

// `_InnerScreen` removido; navegação interna demonstrada na aba Produtos -> ProdutoDetalhe
