// Tela de vagas para o campus João Câmara 
import 'dart:math';
import 'package:estacionamento_app/utils/fade_page_route.dart';
import 'package:flutter/material.dart';
import '../utils/header.dart'; // Cabeçalho personalizado
import 'mapa_ifrn_jc.dart'; // Mapa do campus João Câmara
import 'home_page.dart'; // Página inicial
import 'package:estacionamento_app/mqtt_service.dart';

class VagasJCPage extends StatefulWidget {
  const VagasJCPage({super.key});

  @override
  State<VagasJCPage> createState() => _VagasPageState();
}

class _VagasPageState extends State<VagasJCPage> {
  final MqttService mqttService = MqttService();
  // Aqui é o dicionário que vamos armazenar o status das vagas que vem do mqtt
  Map<String, String> vagaStatus = {};
  // Está lista serve para guardar os valores de forma boleana que vem da comunicação do app com o Broker
  late List<bool> vagasDisponiveis;

  @override
  void initState() {
    super.initState();
    // este código intância 10 valores verdadeiros dentro da lista de "vagasDisponiveis"
    vagasDisponiveis = List.generate(10, (_) => true);
    //comunicação com o broker
    mqttService.onMessageReceived = (topic, message) {
      setState(() {
        vagaStatus[topic] = message;
      });
      // Este codigo torna o dicionário em lista e captura a posição dos valores correspondente ao status de cada vaga;
      // Exemplo da primeira interação: {ha/desafio09/yuri.aquino/ssp/vaga01: "LIVRE"} <---- vagaStatus
      // ["ha/desafio09/yuri.aquino/ssp/vaga01"] <---- vagaStatus.keys.toList()
      // 0 <---- vagaStatus.keys.toList().indexOf(topic), o metodo .indexOf() retorna o valor da posição do topico
           int index = vagaStatus.keys.toList().indexOf(topic);
      // verificar se o "index" é diferente ou igual a -1 para ter certeza se pode ser usado como indexador na lista "vagasDisponiveis"
      if (index != -1) {
        // verificar se a messagem que vem do broker é "LIVRE" e adiciona o valor boleano a lista "vagasDisponiveis" na posicão indicada pelo indexador
        // O status de cada vaga é adicionado respectivamente de acordo com a sua posicao no estacionamento. Ex: a vaga01 corresponde ao primeiro valor da lista "vagadisponiveis" e assim por diante
        vagasDisponiveis[index] = (message == "LIVRE"); // lembrando que "message" vem da comunicaçao com o Broker
      }
    };

    mqttService.connect();
    super.initState();
  }


  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Coloca espaço entre os filhos principais
                children: [
                  // 1. Botão de Voltar (será alinhado à esquerda)
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
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
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Vagas', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 10), // Espaçamento entre os botões
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            FadePageRoute(page: const MapaIFRNJCPage())
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

            // Título que exibe o nome do estacionamento recebido por parâmetro
            const Text(
              'IFRN - JOÃO CÂMARA',
              style: TextStyle(
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
                itemCount: (vagasDisponiveis.length / 2).ceil(), // total de linhas e de acordo com a metade do tamanho da lista
                itemBuilder: (context, i) {
                  int leftIndex = i; // Vagas da esquerda (1 a 5)
                  int rightIndex = i + 5; // Vagas da direira (6 a 10)

                  return Column(

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                         // chamada aa função que mostar o card, passando a posição e o valor boleano (true ou false) do status da vaga
                          _buildVagaCard(leftIndex, vagasDisponiveis[leftIndex]), // vagas: 1, 2, 3, 4, 5

                          _buildVagaCard(rightIndex, vagasDisponiveis[rightIndex]), // vagas: 6, 7, 8, 9, 10


                        ],
                      ),


                      // Linha amarela horizontal entre linhas, exceto a última
                      if (i < (vagasDisponiveis.length / 2).ceil() -1 ) // o tamanho da lista é divido na metade, aredondado  para menos e retirando 1 (para não exibir uma linha apos a ultima posição)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 2,
                                  width: 100,
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
                color: isDisponivel ? Colors.black26 : Colors.black54, // muda a cor de acordo com o valor boleando passado ao chamar a função
              ),
              const SizedBox(width: 10),
              Text(
                isDisponivel ? 'DISPONÍVEL' : 'OCUPADA', // muda o texto de acordo com o valor boleando passado ao chamar a função
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
