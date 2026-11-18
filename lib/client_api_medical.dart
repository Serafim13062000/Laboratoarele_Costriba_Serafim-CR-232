/// ============================================================================
/// Fișierul: client_api_medical.dart
/// Arhitectura: Clean Architecture (Stratul Data - Web Services & Client HTTP)
/// Punctul 3: Integrarea endpoint-urilor API (feed și details).
/// 
/// Descriere detaliată:
/// Gestionează cererile HTTP GET către serverul REST API:
/// 1. Feed: https://test-api-jlbn.onrender.com/lab2026/v2/feed
/// 2. Details: https://test-api-jlbn.onrender.com/lab2026/v2/feed/details
/// Include mesaje de jurnalizare (print) pentru a confirma comunicarea cu serverul.
/// ============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ClientApiMedical {
  static const String _urlFeed = 'https://test-api-jlbn.onrender.com/lab2026/v2/feed';
  static const String _urlDetails = 'https://test-api-jlbn.onrender.com/lab2026/v2/feed/details';

  final http.Client clientHTTP;

  ClientApiMedical({http.Client? client}) : clientHTTP = client ?? http.Client();

  /// Preia datele de la endpoint-ul /feed
  Future<Map<String, dynamic>> preiaFeedApiMap() async {
    try {
      debugPrint('[API Client] Se apelează GET: $_urlFeed');
      final raspuns = await clientHTTP.get(Uri.parse(_urlFeed));
      debugPrint('[API Client] Răspuns primit /feed - Status: ${raspuns.statusCode}');
      
      if (raspuns.statusCode == 200) {
        final dynamic decodat = json.decode(raspuns.body);
        if (decodat is Map<String, dynamic>) {
          return decodat;
        } else if (decodat is Map) {
          return Map<String, dynamic>.from(decodat);
        } else {
          throw Exception('Format JSON invalid pentru /feed');
        }
      } else {
        throw Exception('Eroare HTTP feed: Cod status ${raspuns.statusCode}');
      }
    } catch (e) {
      debugPrint('[API Client] Eroare la /feed: $e');
      rethrow;
    }
  }

  /// Preia datele de la endpoint-ul /feed/details
  Future<Map<String, dynamic>> preiaDetaliiApiMap({String? id}) async {
    try {
      final urlFinal = id != null ? '$_urlDetails?id=$id' : _urlDetails;
      debugPrint('[API Client] Se apelează GET: $urlFinal');
      final raspuns = await clientHTTP.get(Uri.parse(urlFinal));
      debugPrint('[API Client] Răspuns primit /feed/details - Status: ${raspuns.statusCode}');

      if (raspuns.statusCode == 200) {
        final dynamic decodat = json.decode(raspuns.body);
        if (decodat is Map<String, dynamic>) {
          return decodat;
        } else if (decodat is Map) {
          return Map<String, dynamic>.from(decodat);
        } else {
          throw Exception('Format JSON invalid pentru /feed/details');
        }
      } else {
        throw Exception('Eroare HTTP details: Cod status ${raspuns.statusCode}');
      }
    } catch (e) {
      debugPrint('[API Client] Eroare la /feed/details: $e');
      rethrow;
    }
  }
}
