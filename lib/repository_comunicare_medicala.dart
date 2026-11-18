/// ============================================================================
/// Fișierul: repository_comunicare_medicala.dart
/// Arhitectura: Clean Architecture (Stratul Data - Repository Pattern)
/// Punctul 2 (Partea de Date): Comunicarea cu API-ul REST și sursele locale.
/// 
/// Descriere detaliată:
/// Interoghează endpoint-urile API `/feed` și `/feed/details`, transmițând datele
/// către stratul de prezentare. Include jurnalizare pentru a valida fluxul de date.
/// ============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'client_api_medical.dart';
import 'modele_date_medicale.dart';

class RepositoryComunicareMedicala {
  final ClientApiMedical clientApi;

  RepositoryComunicareMedicala({ClientApiMedical? clientApi})
      : clientApi = clientApi ?? ClientApiMedical();

  /// Încarcă datele complete combinând răspunsurile de la ambele endpoint-uri API.
  Future<Map<String, dynamic>> incarcadateMedicaleComplexe() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    Map<String, dynamic> rezultatFinal = {};

    // 1. Preluare feed
    try {
      final feedJson = await clientApi.preiaFeedApiMap();
      rezultatFinal['homeScreen'] = feedJson;
      debugPrint('[Repository] Datele /feed au fost preluate cu succes de la server.');
    } catch (e) {
      debugPrint('[Repository] Atentie: Nu s-a putut prelua /feed de la server. Se folosește fallback local. Detalii: $e');
      final localString = await rootBundle.loadString('assets/data/medical_data.json');
      final Map<String, dynamic> localData = json.decode(localString);
      rezultatFinal['homeScreen'] = localData['homeScreen'];
    }

    // 2. Preluare details
    try {
      final detailsJson = await clientApi.preiaDetaliiApiMap();
      rezultatFinal['appointmentDetails'] = detailsJson;
      debugPrint('[Repository] Datele /feed/details au fost preluate cu succes de la server.');
    } catch (e) {
      debugPrint('[Repository] Atentie: Nu s-a putut prelua /feed/details de la server. Se folosește fallback local. Detalii: $e');
      final localString = await rootBundle.loadString('assets/data/medical_data.json');
      final Map<String, dynamic> localData = json.decode(localString);
      rezultatFinal['appointmentDetails'] = localData['appointmentDetails'];
    }

    return rezultatFinal;
  }

  // Compatibilitate denumire metodă
  Future<Map<String, dynamic>> incarcaDateMedicaleComplexe() async {
    return await incarcadateMedicaleComplexe();
  }

  /// Obține detalii specifice prin API sau fallback local.
  Future<ModelDetaliiApi> obtineDetaliiApi({String? id}) async {
    try {
      final mapDetalii = await clientApi.preiaDetaliiApiMap(id: id);
      return ModelDetaliiApi.fromJson(mapDetalii);
    } catch (e) {
      final localString = await rootBundle.loadString('assets/data/medical_data.json');
      final Map<String, dynamic> localData = json.decode(localString);
      final detailsSec = localData['appointmentDetails'] as Map<String, dynamic>;
      return ModelDetaliiApi.fromJson({
        'id': id ?? 'default',
        'detailsInfo': detailsSec['details']?['description'] ?? '',
        'author': detailsSec['doctor']?['name'] ?? 'Specialist Medical',
        'rating': 4.9,
      });
    }
  }
}
