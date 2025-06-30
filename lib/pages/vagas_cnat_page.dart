// Corresponde à tela de vagas do campus Natal Central (CNAT)
import 'dart:math'; // Para gerar valores aleatórios
import 'package:flutter/material.dart';
import '../utils/header.dart'; // Cabeçalho personalizado

// Widget stateful porque a lista de vagas disponíveis pode mudar
class VagasCNATPage extends StatefulWidget {
  const VagasCNATPage({super.key});

  @override
  State<VagasCNATPage> createState() => _VagasCNATPageState();
}

class _VagasCNATPageState extends State<VagasCNATPage> {
  // Lista que guarda o estado (disponível ou ocupada) das vagas
  late List<bool> vagasDisponiveis;

  @override
  void initState() {
    super.initState();
    // Inicializa a lista com 10 vagas, cada uma com status aleatório (true/false)
    vagasDisponiveis = List.generate(10, (_) => Random().nextBool());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800], // Fundo escuro da tela
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(), // Cabeçalho personalizado no topo

            // Barra branca fixa com botões "Voltar", "Vagas" e "Mapa"
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // Espaço igual entre os botões
                children: [
                  // Botão de voltar com ícone de seta para a esquerda
                  IconButton(
                    onPressed: () => Navigator.pop(context), // Volta para a tela anterior
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: Colors.grey[800], // Cor do ícone
                    tooltip: 'Voltar', // Texto que aparece ao manter pressionado
                  ),

                  // Botão "Vagas" estilizado em azul
                  ElevatedButton(
                    onPressed: () {}, // Ação pode ser definida futuramente
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Vagas', style: TextStyle(color: Colors.white)),
                  ),

                  // Botão "Mapa" com borda azul e texto azul
                  OutlinedButton(
                    onPressed: () {}, // Ação pode ser definida futuramente
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF1976D2)),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Mapa', style: TextStyle(color: Color(0xFF1976D2))),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10), // Espaço entre a barra e o título

            // Título do estacionamento (campus)
            const Text(
              'IFRN - NATAL CENTRAL',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10), // Espaço antes da lista de vagas

            // Lista de vagas que ocupa o restante da tela
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: 5, // 5 linhas de vagas (cada linha tem 2 vagas)
                itemBuilder: (context, i) {
                  int leftIndex = i * 2; // índice da vaga da esquerda
                  int rightIndex = i * 2 + 1; // índice da vaga da direita

                  return Column(
                    children: [
                      // Linha com duas vagas e uma linha amarela vertical no meio
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildVagaCard(leftIndex, vagasDisponiveis[leftIndex]),

                          // Linha amarela vertical entre as vagas
                          Container(
                            width: 2,
                            height: 80,
                            color: Colors.yellow,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                          ),

                          _buildVagaCard(rightIndex, vagasDisponiveis[rightIndex]),
                        ],
                      ),

                      // Linha amarela horizontal separadora entre as linhas, exceto a última
                      if (i < 4)
                        Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          color: Colors.yellow,
                          width: double.infinity,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método que retorna o widget que representa uma vaga
  Widget _buildVagaCard(int numero, bool isDisponivel) {
    return Container(
      width: 150, // largura fixa
      decoration: BoxDecoration(
        color: isDisponivel ? Colors.green[300] : Colors.red[300], // verde se disponível, vermelho se ocupada
        borderRadius: BorderRadius.circular(20), // cantos arredondados
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // espaçamento interno
      child: Column(
        children: [
          // Número da vaga (ajustado para começar de 1)
          Text(
            '${numero + 1}',
            style: const TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8), // espaçamento vertical

          // Status da vaga com ícone e texto
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                size: 16,
                color: isDisponivel ? Colors.black26 : Colors.black54, // cor do ícone conforme status
              ),
              const SizedBox(width: 10),
              Text(
                isDisponivel ? 'DISPONÍVEL' : 'OCUPADA',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
