import 'package:flutter/material.dart';
import 'authentification.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paye ton kawa',
      theme: ThemeData(),
      home: const Authentification(title: 'Accueil'),
    );
  }
}
