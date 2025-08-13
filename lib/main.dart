import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário de Cadastro',
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.blue.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.blue.shade700),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: Colors.blue.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: const FormularioCadastro(),
    );
  }
}

class FormularioCadastro extends StatefulWidget {
  const FormularioCadastro({super.key});

  @override
  State<FormularioCadastro> createState() => _FormularioCadastroState();
}

class _FormularioCadastroState extends State<FormularioCadastro> {
  final List<_PessoaFormData> _pessoas = [_PessoaFormData()];

  void _adicionarCard() {
    setState(() {
      _pessoas.add(_PessoaFormData());
    });
  }

  void _removerCard(int index) {
    if (_pessoas.length == 1) return;
    setState(() {
      _pessoas[index].dispose();
      _pessoas.removeAt(index);
    });
  }

  Future<void> _selecionarDataPara(int index) async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Selecione sua data de nascimento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (dataEscolhida != null) {
      setState(() {
        _pessoas[index].dataNascimento = dataEscolhida;
      });
    }
  }

  void _enviarTodos() {
    for (int i = 0; i < _pessoas.length; i++) {
      final pessoa = _pessoas[i];
      final valido = pessoa.formKey.currentState?.validate() ?? false;
      if (!valido) {
        _mostrarSnackBar('Verifique os campos do card ${i + 1}', Colors.red);
        return;
      }
      if (pessoa.dataNascimento == null) {
        _mostrarSnackBar(
          'Selecione a data de nascimento no card ${i + 1}',
          Colors.red,
        );
        return;
      }
      if (pessoa.sexo == null) {
        _mostrarSnackBar('Selecione o sexo no card ${i + 1}', Colors.red);
        return;
      }
    }

    _mostrarSnackBar('Dados salvos com sucesso!', Colors.green);

    for (int i = 0; i < _pessoas.length; i++) {
      final p = _pessoas[i];
      debugPrint('Card ${i + 1}');
      debugPrint('  Nome: ${p.nomeController.text}');
      debugPrint('  Data de Nascimento: ${p.dataNascimento}');
      debugPrint('  Sexo: ${p.sexo}');
    }
  }

  void _mostrarSnackBar(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    for (final pessoa in _pessoas) {
      pessoa.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header moderno
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade600,
                              Colors.blue.shade400,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade300,
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_add_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Criar Conta',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Preencha seus dados para começar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Carrossel de cards (micro-formulários)
                SizedBox(
                  height: 360,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, index) {
                      final pessoa = _pessoas[index];
                      return SizedBox(
                        width: 340,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade100,
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: pessoa.formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.badge_rounded,
                                          color: Colors.blue.shade600,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Formulário ${index + 1}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade800,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    TextFormField(
                                      controller: pessoa.nomeController,
                                      decoration: InputDecoration(
                                        labelText: 'Nome Completo',
                                        prefixIcon: Icon(
                                          Icons.person_rounded,
                                          color: Colors.blue.shade600,
                                        ),
                                        hintText: 'Digite o nome completo',
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Por favor, digite o nome completo';
                                        }
                                        if (value.trim().split(' ').length <
                                            2) {
                                          return 'Digite nome e sobrenome';
                                        }
                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 16),

                                    InkWell(
                                      onTap: () => _selecionarDataPara(index),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.blue.shade200,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today_rounded,
                                              color: Colors.blue.shade600,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Data de Nascimento',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.blue.shade700,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    pessoa.dataNascimento ==
                                                            null
                                                        ? 'Selecione a data'
                                                        : '${pessoa.dataNascimento!.day.toString().padLeft(2, '0')}/'
                                                              '${pessoa.dataNascimento!.month.toString().padLeft(2, '0')}/'
                                                              '${pessoa.dataNascimento!.year}',
                                                    style: TextStyle(
                                                      color:
                                                          pessoa.dataNascimento ==
                                                              null
                                                          ? Colors.grey.shade600
                                                          : Colors
                                                                .blue
                                                                .shade800,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          pessoa.dataNascimento ==
                                                              null
                                                          ? FontWeight.normal
                                                          : FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    DropdownButtonFormField<String>(
                                      value: pessoa.sexo,
                                      decoration: InputDecoration(
                                        labelText: 'Sexo',
                                        prefixIcon: Icon(
                                          Icons.wc_rounded,
                                          color: Colors.blue.shade600,
                                        ),
                                        hintText: 'Selecione o sexo',
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'Homem',
                                          child: Text('Homem'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Mulher',
                                          child: Text('Mulher'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          pessoa.sexo = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Selecione o sexo';
                                        }
                                        return null;
                                      },
                                    ),

                                    const Spacer(),

                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        'Arraste para o lado para mais cartões',
                                        style: TextStyle(
                                          color: Colors.blue.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_pessoas.length > 1)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Material(
                                  color: Colors.red.shade50,
                                  shape: const CircleBorder(),
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () => _removerCard(index),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: Colors.red.shade400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemCount: _pessoas.length,
                  ),
                ),

                const SizedBox(height: 16),

                // Ações
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _adicionarCard,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Adicionar Card'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.blue.shade300),
                          foregroundColor: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade600,
                              Colors.blue.shade500,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade300,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _enviarTodos,
                          icon: const Icon(
                            Icons.save_rounded,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Salvar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Informações
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade50,
                        Colors.blue.shade100.withValues(alpha: 0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_rounded,
                            color: Colors.blue.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Como funciona',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildRequirement(
                        'Arraste na horizontal para navegar entre os cards',
                      ),
                      _buildRequirement(
                        'Cada card contém Nome, Data de Nascimento e Sexo',
                      ),
                      _buildRequirement(
                        'Use o botão Adicionar para criar novos cards',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.blue.shade700, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _PessoaFormData {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  DateTime? dataNascimento;
  String? sexo;

  void dispose() {
    nomeController.dispose();
  }
}
