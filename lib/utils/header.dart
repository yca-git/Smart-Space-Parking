//utils/header.dart
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const azulEscuro = Color(0xFF0D47A1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: azulEscuro,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
    );
  }
}
