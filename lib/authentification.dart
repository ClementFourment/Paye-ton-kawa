import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import 'qrCode.dart';

class Authentification extends StatefulWidget {
  const Authentification({super.key, required this.title});

  final String title;

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
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
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.6,
              scale: 10,
              alignment: FractionalOffset(-0.03, 0.2),
              image: NetworkImage("https://clemfourment.fr/logo/logo.png"),
              repeat: ImageRepeat.repeat,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 36),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      backgroundColor: const Color.fromARGB(190, 63, 46, 0)
                          .withOpacity(0.95),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QRCode(
                            title: 'QR Code',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Se connecter",
                      style: TextStyle(
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
