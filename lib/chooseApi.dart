import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'articleList.dart';
import 'Revendeur.dart';
import 'homePage.dart';
import 'productsPage.dart';

class ChooseApi extends StatefulWidget {
  const ChooseApi({super.key, required this.title});

  final String title;
  @override
  State<ChooseApi> createState() => _ChooseApiState();
}

class _ChooseApiState extends State<ChooseApi> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarColor(
        const Color.fromARGB(255, 255, 255, 255));
    AppBar appBar = AppBar(
        backgroundColor: const Color.fromARGB(190, 63, 46, 0),
        title: const Text(
          "Paye ton kawa",
          style: TextStyle(fontFamily: 'Satisfy-Regular', fontSize: 28),
        ));
    return MaterialApp(
      home: Scaffold(
        appBar: appBar,
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Center(
            child: SizedBox(
              width: 300,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 36),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  backgroundColor:
                      const Color.fromARGB(190, 63, 46, 0).withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductsPage(
                        title: 'QR Code',
                      ),
                    ),
                  );
                },
                child: const Text(
                  "API FOURNIE",
                  style: TextStyle(
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ),
          const Divider(thickness: 5),
          Center(
            child: SizedBox(
              width: 300,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 36),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  backgroundColor:
                      const Color.fromARGB(190, 63, 46, 0).withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(
                        title: 'QR Code',
                      ),
                    ),
                  );
                },
                child: const Text(
                  "NOTRE API",
                  style: TextStyle(
                    color: Color(0xffffffff),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
