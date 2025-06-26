import 'package:estacionamento_app/utils/fade_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import '../utils/header.dart';
import 'package:url_launcher/url_launcher.dart'; // Import para abrir URLs
import 'vagas_zn_page.dart';

// Coordenadas do IFRN CNAT (Campus Natal - Central)
// Substitua pelas coordenadas EXATAS se estas não forem precisas.
const latlong.LatLng mapaIFRNzn = latlong.LatLng(-5.749124, -35.260414); // Substitua pelas coordenadas corretas
const String _nomeCampus = "IFRN - Campus Natal - Zona Norte";
const String _googleMapsUrlIFRNCNAT = "https://maps.app.goo.gl/zLMqviJbA1PkP39VA"; // Ajuste a URL com as coordenadas corretas


class mapaIFRNz extends StatefulWidget {
  const mapaIFRNz({super.key});

  @override
  State<mapaIFRNz> createState() => _mapaIFRNzState();
}

class _mapaIFRNzState extends State<mapaIFRNz> {
  final MapController _mapController = MapController();

  // Função para abrir o link no Google Maps
  Future<void> _abrirNoGoogleMaps() async {
    final Uri url = Uri.parse(_googleMapsUrlIFRNCNAT);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication); // Abre no app do Google Maps se disponível
    } else {
      // Tratar erro: não foi possível abrir o link
      if (mounted) { // Boa prática verificar se o widget ainda está montado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o Google Maps.')),
        );
      }
      print('Não foi possível abrir a URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cores (você pode ter estas definidas globalmente ou passadas como parâmetro)
    const Color azulEscuro = Color(0xFF0D47A1); // Cor do cabeçalho
    const Color azulBotao = Color(0xFF1976D2);  // Cor dos botões

    return Scaffold(
      backgroundColor: Colors.grey[100], // Um fundo leve para a tela
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabeçalho
            const HeaderWidget(),

            // 2. CONTAINER COM BOTÕES (VOLTAR, VAGAS, MAPA)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Coloca espaço entre os filhos principais
                children: [
                  // 1. Botão de Voltar, leva até pag de vagas
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        FadePageRoute(page: const VagasZNPage()),); //efeito fade
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
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            FadePageRoute(page: const VagasZNPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF1976D2)),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Vagas', style: TextStyle(color: Color(0xFF1976D2))),
                      ),
                      const SizedBox(width: 10), // Espaçamento entre os botões
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Mapa', style: TextStyle(color: Colors.white)),
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

            const SizedBox(height: 16),

            // 3. IDENTIFICAÇÃO DO CAMPUS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _nomeCampus,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 4. MAPA COM A LOCALIZAÇÃO
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ClipRRect( // Para dar bordas arredondadas ao mapa se desejar
                  borderRadius: BorderRadius.circular(12.0),
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: mapaIFRNzn,
                      initialZoom: 17.0, // Zoom mais apropriado para visualização de campus
                      minZoom: 10.0,
                      maxZoom: 19.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.estacionamento_app', // nome do pacote
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: mapaIFRNzn,
                            child: Tooltip(
                              message: _nomeCampus,
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.red.shade700,
                                size: 45.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10), // Espaço entre o mapa e o botão

            // 5. BOTÃO PARA GOOGLE MAPS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.map_outlined, color: Colors.white),
                label: const Text('Abrir no Google Maps', style: TextStyle(color: Colors.white, fontSize: 16)),
                onPressed: _abrirNoGoogleMaps,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}