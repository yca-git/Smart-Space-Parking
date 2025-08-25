// Importação dos pacotes necessários
import 'package:flutter/material.dart';
import 'home_page.dart'; // Importa a tela de destino após login

// Tela de login (primeira tela do app)
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Define o fundo azul principal da tela
      backgroundColor: const Color(0xFF0074D9),

      // SafeArea evita que o conteúdo fique embaixo da status bar (Android/iOS)
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
            children: [
              // Ícone de localização com ícone de carro centralizado
              Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.location_on, // Ícone de localização
                    size: 150,
                    color: Colors.white,
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF0074D9), // Fundo azul central
                    ),
                  ),
                  const Icon(
                    Icons.directions_car, // Ícone de carro dentro da localização
                    size: 40,
                    color: Colors.white,
                  ),
                ],
              ),

              const SizedBox(height: 20), // Espaço entre ícone e texto

              // Nome do sistema
              const Text(
                'SMART SPACE PARKING',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 8), // Espaço entre textos

              // Subtítulo explicativo
              const Text(
                'MONITORAMENTO INTELIGENTE DE ESTACIONAMENTO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40), // Espaço antes do botão

              // Botão "Entrar"
              ElevatedButton(
                onPressed: () {
                  // Ao pressionar, substitui a tela de login pela tela inicial (HomePage)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Cor do botão
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Bordas arredondadas
                  ),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    color: Color(0xFF0074D9), // Cor do texto
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
