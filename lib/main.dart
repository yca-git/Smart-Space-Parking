import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const EstacionamentoApp());
}

class EstacionamentoApp extends StatelessWidget {
  const EstacionamentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estacionamento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[100],
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
