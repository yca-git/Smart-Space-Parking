// Tela de vagas do campus Natal Central (CNAT)
import 'dart:math'; // Para gerar valores aleatórios
import 'package:flutter/material.dart';
import '../utils/header.dart'; // Cabeçalho personalizado
import 'mapa_ifrn_cnat.dart'; // Mapa do campus NATAL Central
import 'home_page.dart';
import '../utils/fade_page_route.dart'; // Rota personalizada com transição em fade


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
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Coloca espaço entre os filhos principais
                children: [
                  // 1. Botão de Voltar (será alinhado à esquerda)
                  IconButton( // Botão de voltar
                    onPressed: () {
                      Navigator.push(
                        context,
                        FadePageRoute(page: const HomePage()
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
                      ElevatedButton( // Botão "Vagas"
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Vagas', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 10), // Espaçamento entre os botões
                      OutlinedButton( // Botão "Mapa"
                        onPressed: () {
                          Navigator.push(
                            context,
                            FadePageRoute(page: const MapaIFRNCNATPage()),
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

                          _buildVagaCard(rightIndex, vagasDisponiveis[rightIndex]),
                        ],
                      ),

                      // Linha amarela horizontal separadora entre as linhas, exceto a última
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
