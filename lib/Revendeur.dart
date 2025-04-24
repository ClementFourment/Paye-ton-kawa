import 'dart:convert';

class Revendeur {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String qrCode;

  const Revendeur(
    this.id,
    this.nom,
    this.prenom,
    this.email,
    this.qrCode,
  );
}
