// Corresponde a tela 2 - inicial `selecione o estacionamento`

// Importação dos pacotes necessários
import 'package:flutter/material.dart';
import 'vagas_page.dart';            // Página específica para João Câmara
import 'vagas_zn_page.dart';        // Página específica para Natal ZN
import 'vagas_cnat_page.dart';      // Página específica para CNAT
import '../utils/fade_page_route.dart'; // Rota personalizada com transição em fade

// Definição da HomePage, que é um StatelessWidget (não precisa de estado)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Função para abrir a página de vagas correspondente
  void _openVagasPage(BuildContext context, String nomeEstacionamento) {
    Widget destino;

    // Decide qual página abrir com base no nome do estacionamento
    if (nomeEstacionamento == 'IFRN - JOÃO CÂMARA') {
      destino = VagasPage(nomeEstacionamento: nomeEstacionamento);
    } else if (nomeEstacionamento == 'IFRN - NATAL ZN') {
      destino = const VagasZNPage();
    } else if (nomeEstacionamento == 'IFRN - NATAL CNAT') {
      destino = const VagasCNATPage();
    } else {
      // Fallback para página genérica
      destino = VagasPage(nomeEstacionamento: nomeEstacionamento);
    }

    // Abre a nova tela com transição em fade
    Navigator.push(
      context,
      FadePageRoute(page: destino),
    );
  }

  @override
  Widget build(BuildContext context) { // Método build para construir a tela
    // Cores principais utilizadas
    const azulEscuro = Color(0xFF0D47A1); // Cor do cabeçalho
    const azulBotao = Color(0xFF1976D2);  // Cor dos botões

    return Scaffold( // Tela principal
      backgroundColor: Colors.white, // Cor de fundo da página
      body: SafeArea( // Permite que o conteúdo esteja dentro dos limites da tela
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com ícone e título
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: azulEscuro,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Ícone de localização com carro dentro
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 40,
                        color: Colors.white,
                      ),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: azulEscuro,
                        ),
                      ),
                      const Icon(
                        Icons.directions_car,
                        size: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'SMART SPACE PARKING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40), // Espaço abaixo do cabeçalho

            // Texto centralizado instruindo o usuário
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

            const SizedBox(height: 40), // Espaço entre texto e botões

            // Botões de seleção de campus
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  // Botão 1
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

                  // Botão 2
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

                  // Botão 3
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
    );
  }
}
