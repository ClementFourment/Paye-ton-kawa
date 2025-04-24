import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:paye_ton_kawa/Revendeur.dart';
import 'package:paye_ton_kawa/qrCode.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group('fetchQrCode', () {
    test('returns an Revendeur if the http call completes successfully',
        () async {
      QRCodeState qrCodeState = QRCodeState();

      const json =
          '[{"id" : 67, "nom" : "Leonard", "prenom" : "Antonin", "email" : "antonin.leonard@epsi.fr","qrCode" : "_FSEb0wFDkYyzfbaq63A/;I~Ak-3SF" }]';

      Revendeur revFake = const Revendeur(67, "Leonard", "Antonin",
          "antonin.leonard@epsi.fr", "_FSEb0wFDkYyzfbaq63A/;I~Ak-3SF");

      Revendeur finalRevendeur = const Revendeur(-1, '', '', '', '');

      final response = await http.get(Uri.parse(
          'https://clemfourment.fr/listRevendeur.php?api_key=k7M58iSTK2qcfgT7R3Em8G3mCH825qRv4Map'));
      String code = "_FSEb0wFDkYyzfbaq63A/;I~Ak-3SF";
      finalRevendeur = await qrCodeState.auth(response, code);

      final clientMock = MockClient((_) async => http.Response(json, 200));

      final resMock =
          await clientMock.get(Uri.parse('https://jsonplaceholderFakeUrl'));
      var futureRev =
          await qrCodeState.auth(resMock, "_FSEb0wFDkYyzfbaq63A/;I~Ak-3SF");
      Revendeur revMock = futureRev;

      identical(revFake, revMock);
      expect(revFake.id, revMock.id);
      expect(revFake.nom, revMock.nom);
      expect(revFake.prenom, revMock.prenom);
      expect(revFake.email, revMock.email);
      expect(revFake.qrCode, revMock.qrCode);

      identical(revFake, finalRevendeur);
      expect(revFake.id, finalRevendeur.id);
      expect(revFake.nom, finalRevendeur.nom);
      expect(revFake.prenom, finalRevendeur.prenom);
      expect(revFake.email, finalRevendeur.email);
      expect(revFake.qrCode, finalRevendeur.qrCode);
      expect(await qrCodeState.auth(response, "_FSEb0wFDkYyzfbaq63A/;I~Ak-3SF"),
          isA<Revendeur>());
    });
  });
}
