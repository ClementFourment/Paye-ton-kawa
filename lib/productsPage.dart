import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'productsList.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.title});

  final String title;
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarColor(
        const Color.fromARGB(255, 255, 255, 255));
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(190, 63, 46, 0),
          title: const Text(
            "Paye ton kawa",
            style: TextStyle(fontFamily: 'Satisfy-Regular', fontSize: 28),
          ),
        ),
        body: Column(children: const [
          Expanded(
            child: ProductsList(),
          ),
        ]),
      ),
    );
  }
}
