// Tela de vagas para o campus Natal Zona Norte (ZN)
import 'dart:math'; // Para gerar valores aleatórios
import 'package:estacionamento_app/utils/fade_page_route.dart';
import 'package:flutter/material.dart';
import '../utils/header.dart'; // Cabeçalho personalizado
import 'home_page.dart'; // Página inicial
import '../utils/fade_page_route.dart';
import 'mapa_ifrn_zn.dart'; // Mapa da zona norte

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Coloca espaço entre os filhos principais
                children: [
                  // 1. Botão de Voltar, pressionado leva a página inicial com transição em fade
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        FadePageRoute(
                            page: const HomePage()
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: Colors.grey[800],
                    tooltip: 'Voltar',
                  ),

                  // 2. Container/Row para os dois botões que queremos agrupar
                  //    Eles ficarão no centro porque o 'spaceBetween' da Row pai
                  //    atuará sobre este grupo como um único item e o IconButton.
                  //    Se este grupo for o único item restante no centro, ele será centralizado.
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton( // Botão Vagas, pressionado não faz nada
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Vagas', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 10), // Espaçamento entre os botões
                      OutlinedButton( // Botão Mapa, pressionado leva a página do mapa zn com transição em fade
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            FadePageRoute(
                              page: const mapaIFRNz()
                            )
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF1976D2)),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Mapa', style: TextStyle(color: Color(0xFF1976D2))),
                      ),
                    ],
                  ),

                  // 3. Um Widget de "espaço vazio" do mesmo tamanho do IconButton para balancear,
                  //    ou um SizedBox com largura específica se precisar de mais controle.
                  //    Isso ajuda a manter o grupo central realmente no centro.
                  //    Se o botão de voltar tiver uma largura intrínseca, podemos tentar replicá-la
                  //    ou usar um Opacity com um IconButton idêntico para ocupar o espaço.
                  //    Uma abordagem mais simples é apenas deixar um SizedBox.shrink() se o
                  //    `spaceBetween` já centralizar bem o suficiente.
                  //    Para um melhor balanceamento, podemos usar um SizedBox com a largura aproximada do IconButton
                  //    ou um const Spacer() se não houver mais nada à direita.
                  //    Neste caso específico, com apenas 3 "grupos" (IconButton, Row, e nada depois),
                  //    o Row central será posicionado no meio do espaço entre o IconButton e a borda direita.
                  //    Para um melhor efeito de centralização dos dois botões, a Opção 1 com dois Spacers é mais robusta.
                  //    Se quisermos que os dois botões fiquem "mais ou menos no centro",
                  //    e o botão de voltar à esquerda, podemos precisar adicionar um
                  //    widget invisível à direita para balancear com o spaceBetween.

                  // Para esta opção, vamos simplificar e assumir que o `spaceBetween`
                  // com o IconButton à esquerda e o Row (Vagas, Mapa) à direita
                  // já posiciona o Row suficientemente no centro.
                  // Se não, vamos precisar de um item "fantasma" à direita.

                  // Para um alinhamento mais preciso no centro com spaceBetween e 3 itens:
                  // ItemEsquerda - ItemCentral - ItemDireita (deve ter a mesma "largura visual" que o ItemEsquerda)
                  // No nosso caso, o terceiro item é implícito (a borda direita).
                  // Se o grupo central não estiver perfeitamente centralizado, a Opção 1 é melhor.
                  // Vamos tentar sem um terceiro item explícito para ver o efeito do spaceBetween.
                  // Se o grupo (Vagas, Mapa) estiver muito à direita, a Opção 1 é preferível.

                  // Para forçar a centralização com spaceBetween, precisaríamos de algo assim:
                  SizedBox(width: 48), // Tente ajustar este valor para ser similar à largura do IconButton
                  // ou use um widget `Opacity` com um IconButton idêntico.
                  // No entanto, isso é menos flexível que `Spacer`.
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
                  int leftIndex = i; // índice da vaga da esquerda
                  int rightIndex = i + 5;

                  return Column(
                    children: [
                      // Linha com duas vagas e linha amarela vertical entre elas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildVagaCard(leftIndex, vagasDisponiveis[leftIndex]),
                          _buildVagaCard(rightIndex, vagasDisponiveis[rightIndex]),
                        ],
                      ),

                      // Linha amarela horizontal separando as linhas (exceto a última)
                      if (i < 4)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 2,
                                  width: 100, // Reduzir para evitar overflow
                                  color: Colors.yellow[400],
                                ),
                                Container(
                                  height: 2,
                                  width: 100,
                                  color: Colors.yellow[400],
                                ),
                              ],
                            ),
                          ),
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
