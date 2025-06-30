// Corresponde a tela 2 - inicial `selecione o estacionamento`

// Importação dos pacotes necessários
import 'package:flutter/material.dart';
import 'vagas_page.dart';            // Página específica para João Câmara
import 'vagas_zn_page.dart';        // Página específica para Natal ZN
import 'vagas_cnat_page.dart';
import '../utils/header.dart';// Rota para cabeçalho padrão
import '../utils/fade_page_route.dart'; // Rota personalizada com transição em fade

// Definição da HomePage, que é um StatelessWidget (não precisa de estado)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Função para abrir a página de vagas correspondente
  void _openVagasPage(BuildContext context, String nomeEstacionamento) {
    Widget destino;

    // Decide qual página abrir com base no nome do estacionamento
    if (nomeEstacionamento == 'IFRN - JOÃO CÂMARA') {
      destino = const VagasJCPage();
    } else if (nomeEstacionamento == 'IFRN - NATAL ZN') {
      destino = const VagasZNPage();
    } else if (nomeEstacionamento == 'IFRN - NATAL CNAT') {
      destino = const VagasCNATPage();
    } else {
      // Fallback para página genérica
      destino = const VagasJCPage();
    }

    // Abre a nova tela com transição em fade
    Navigator.push(
      context,
      FadePageRoute(page: destino),
    );
  }

  @override
  Widget build(BuildContext context) {
    const azulEscuro = Color(0xFF0D47A1);
    const azulBotao = Color(0xFF1976D2);

    return WillPopScope( // Intercepta o botão "voltar"
      onWillPop: () async {
        // Mostra um alerta perguntando se deseja sair do app
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sair do aplicativo'),
            content: const Text('Você deseja realmente sair do aplicativo?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sim'),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderWidget(),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'SELECIONE O ESTACIONAMENTO',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => _openVagasPage(context, 'IFRN - JOÃO CÂMARA'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulBotao,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      child: const Text(
                        'IFRN - JOÃO CÂMARA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _openVagasPage(context, 'IFRN - NATAL ZN'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulBotao,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      child: const Text(
                        'IFRN - NATAL ZN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _openVagasPage(context, 'IFRN - NATAL CNAT'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulBotao,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      child: const Text(
                        'IFRN - NATAL CNAT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
