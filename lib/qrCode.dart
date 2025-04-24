import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:http/http.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'Revendeur.dart';
import 'chooseApi.dart';

class QRCode extends StatefulWidget {
  const QRCode({super.key, required this.title});

  final String title;

  @override
  State<QRCode> createState() => QRCodeState();
}

class QRCodeState extends State<QRCode> with SingleTickerProviderStateMixin {
  MobileScannerController cameraController = MobileScannerController(
    torchEnabled: false,
  );
  double _zoomFactor = 0.0;

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
        body: Builder(
          builder: (context) {
            return Stack(
              children: [
                MobileScanner(
                  //allowDuplicates: false,
                  controller: cameraController,
                  onDetect: (BarcodeCapture capture) {
                    if (capture.barcodes.last.rawValue == null) {
                      debugPrint('Failed to scan Barcode');
                    } else {
                      final String code = capture.barcodes.last.rawValue!;
                      debugPrint('Barcode found! $code');

                      authentificationQrCode(code, cameraController);
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 100,
                    color: Colors.black.withOpacity(0.4),
                    child: Column(
                      children: [
                        Slider(
                          value: _zoomFactor,
                          onChanged: (value) {
                            setState(() {
                              _zoomFactor = value;
                              cameraController.setZoomScale(value);
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              color: Colors.white,
                              icon: ValueListenableBuilder(
                                valueListenable: cameraController.torchState,
                                builder: (context, state, child) {
                                  if (state == null) {
                                    return const Icon(
                                      Icons.flash_off,
                                      color: Colors.grey,
                                    );
                                  }
                                  switch (state) {
                                    case TorchState.off:
                                      return const Icon(
                                        Icons.flash_off,
                                        color: Colors.grey,
                                      );
                                    case TorchState.on:
                                      return const Icon(
                                        Icons.flash_on,
                                        color: Colors.yellow,
                                      );
                                  }
                                },
                              ),
                              iconSize: 32.0,
                              onPressed: () => cameraController.toggleTorch(),
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: ValueListenableBuilder(
                                valueListenable:
                                    cameraController.cameraFacingState,
                                builder: (context, state, child) {
                                  if (state == null) {
                                    return const Icon(Icons.camera_front);
                                  }
                                  switch (state) {
                                    case CameraFacing.front:
                                      return const Icon(Icons.camera_front);
                                    case CameraFacing.back:
                                      return const Icon(Icons.camera_rear);
                                  }
                                },
                              ),
                              iconSize: 32.0,
                              onPressed: () => cameraController.switchCamera(),
                            ),
                          ],
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
    );
  }

  Future<Revendeur> auth(Response response, String code) async {
    Revendeur finalRevendeur = const Revendeur(-1, '', '', '', '');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final revendeurTemp = [];
      final revendeurs = [];
      data.forEach((element) => {revendeurTemp.add(element)});

      revendeurTemp.forEach(
        (element) => {
          if (element["qrCode"] == code)
            {
              finalRevendeur = Revendeur(
                element["id"],
                element["nom"],
                element["prenom"],
                element["email"],
                element["qrCode"],
              ),
            }
        },
      );
    }

    return finalRevendeur;
  }

  Future<Revendeur> authentificationQrCode(
    code,
    MobileScannerController cameraController,
  ) async {
    Revendeur finalRevendeur = const Revendeur(-1, '', '', '', '');

    final response = await http.get(Uri.parse(
        'https://clemfourment.fr/listRevendeur.php?api_key=k7M58iSTK2qcfgT7R3Em8G3mCH825qRv4Map'));

    finalRevendeur = await auth(response, code);

    if (finalRevendeur.id != -1) {
      cameraController.dispose();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Authentification'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Vous êtes déjà authentifié.'),
                  Text("Voulez-vous continuer vers l'application?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Continuer'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChooseApi(
                        title: 'QR Code',
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );

      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChooseApi(
              title: 'PayeTonKawa',
            ),
          ));
    } else {
      //POPUP "Le QR Code flashé ne correspond à aucun revendeur. Veuillez réessayer."
      showDialog(
          context: context,
          builder: (_) => const Dialog(
                backgroundColor: Colors.transparent,
                child: Text(
                  "Le QR Code flashé ne correspond à aucun revendeur.\nCliquer pour réessayer.",
                  style: TextStyle(
                    fontSize: 28,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ));
    }
    return finalRevendeur;
  }
}
