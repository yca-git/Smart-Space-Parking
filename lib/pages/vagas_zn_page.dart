// Tela de vagas para o campus Natal Zona Norte (ZN)
import 'dart:math'; // Para gerar valores aleatórios
import 'package:flutter/material.dart';
import '../utils/header.dart'; // Cabeçalho personalizado

// Stateful pois o status das vagas é variável
class VagasZNPage extends StatefulWidget {
  const VagasZNPage({super.key});

  @override
  State<VagasZNPage> createState() => _VagasZNPageState();
}

class _VagasZNPageState extends State<VagasZNPage> {
  late List<bool> vagasDisponiveis;

  @override
  void initState() {
    super.initState();
    // Inicializa 10 vagas com status aleatório (disponível ou ocupada)
    vagasDisponiveis = List.generate(10, (_) => Random().nextBool());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800], // Fundo escuro
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(), // Cabeçalho no topo

            // Barra branca com botão voltar, e botões Vagas e Mapa
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Botão voltar (seta para esquerda)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: Colors.grey[800],
                    tooltip: 'Voltar',
                  ),

                  // Botão Vagas azul com cantos arredondados
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Vagas', style: TextStyle(color: Colors.white)),
                  ),

                  // Botão Mapa com borda azul e texto azul
                  OutlinedButton(
                    onPressed: () {},
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

            const SizedBox(height: 10),

            // Título do estacionamento
            const Text(
              'IFRN - NATAL ZONA NORTE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            // Lista de vagas
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: 5, // 5 linhas de vagas
                itemBuilder: (context, i) {
                  int leftIndex = i * 2;
                  int rightIndex = i * 2 + 1;

                  return Column(
                    children: [
                      // Linha com duas vagas e linha amarela vertical entre elas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildVagaCard(leftIndex, vagasDisponiveis[leftIndex]),
                          Container(
                            width: 2,
                            height: 80,
                            color: Colors.yellow,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                          ),
                          _buildVagaCard(rightIndex, vagasDisponiveis[rightIndex]),
                        ],
                      ),

                      // Linha amarela horizontal separando as linhas (exceto a última)
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

  // Widget para exibir cada vaga individualmente
  Widget _buildVagaCard(int numero, bool isDisponivel) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: isDisponivel ? Colors.green[300] : Colors.red[300], // verde ou vermelho
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Text(
            '${numero + 1}', // número da vaga começando em 1
            style: const TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                size: 16,
                color: isDisponivel ? Colors.black26 : Colors.black54,
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
