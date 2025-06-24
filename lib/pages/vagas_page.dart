// Tela de vagas para o campus João Câmara 
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/header.dart'; // Cabeçalho personalizado

class VagasPage extends StatefulWidget {
  final String nomeEstacionamento; // Nome do estacionamento para exibir

  const VagasPage({super.key, required this.nomeEstacionamento});

  @override
  State<VagasPage> createState() => _VagasPageState();
}

class _VagasPageState extends State<VagasPage> {
  late List<bool> vagasDisponiveis;

  @override
  void initState() {
    super.initState();
    // Inicializa as vagas com status aleatório (disponível ou ocupada)
    vagasDisponiveis = List.generate(10, (_) => Random().nextBool());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800], // fundo escuro
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(), // cabeçalho no topo

            // Barra branca fixa com botão voltar e botões Vagas/Mapa
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context), // volta à tela anterior
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: Colors.grey[800],
                    tooltip: 'Voltar',
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Vagas', style: TextStyle(color: Colors.white)),
                  ),
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

            // Título que exibe o nome do estacionamento recebido por parâmetro
            Text(
              widget.nomeEstacionamento,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            // Lista de vagas exibida em linhas, com duas vagas por linha
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: 5, // 5 linhas, 2 vagas por linha = 10 vagas
                itemBuilder: (context, i) {
                  int leftIndex = i * 2;
                  int rightIndex = i * 2 + 1;

                  return Column(
                    children: [
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

                      // Linha amarela horizontal entre linhas, exceto a última
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

  // Widget para exibir cada vaga
  Widget _buildVagaCard(int numero, bool isDisponivel) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: isDisponivel ? Colors.green[300] : Colors.red[300], // verde para disponível, vermelho para ocupada
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Text(
            '${numero + 1}', // Número da vaga começando em 1
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
