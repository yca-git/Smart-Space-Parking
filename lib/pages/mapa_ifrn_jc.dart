import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import '../utils/header.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:estacionamento_app/pages/vagas_page.dart';
import 'package:estacionamento_app/utils/fade_page_route.dart';

// Coordenadas do IFRN João Câmara
const latlong.LatLng _coordenadasIFRNJC = latlong.LatLng(-5.543635, -35.797856);
const String _nomeCampus = "IFRN - Campus João Câmara";
const String _googleMapsUrlIFRNJC = "https://maps.app.goo.gl/ZMMH56dCFZVicQLD9";

class MapaIFRNJCPage extends StatefulWidget {
  const MapaIFRNJCPage({super.key});

  @override
  State<MapaIFRNJCPage> createState() => _MapaIFRNJCPageState();
}

class _MapaIFRNJCPageState extends State<MapaIFRNJCPage> {
  final MapController _mapController = MapController();

  Future<void> _abrirNoGoogleMaps() async {
    final Uri url = Uri.parse(_googleMapsUrlIFRNJC);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o Google Maps.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color azulEscuro = Color(0xFF0D47A1);
    const Color azulBotao = Color(0xFF1976D2);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabeçalho
            const HeaderWidget(),

            // Barra de ações
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        FadePageRoute(page: const VagasJCPage()),);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: Colors.grey[800],
                    tooltip: 'Voltar',
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton( // Botão de Vagas
                        onPressed: () {Navigator.pushReplacement(
                          context,
                          FadePageRoute(page: const VagasJCPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: azulBotao),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Vagas', style: TextStyle(color: azulBotao)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton( // Botão de mapa
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azulBotao,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Mapa', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 16),

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

            // Mapa
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _coordenadasIFRNJC,
                      initialZoom: 17.0,
                      minZoom: 10.0,
                      maxZoom: 19.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.estacionamento_app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: _coordenadasIFRNJC,
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

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.map_outlined, color: Colors.white),
                label: const Text('Abrir no Google Maps', style: TextStyle(color: Colors.white, fontSize: 16)),
                onPressed: _abrirNoGoogleMaps,
                style: ElevatedButton.styleFrom(
                  backgroundColor: azulBotao,
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
