/// ============================================================================
/// Fișierul: modele_date_medicale.dart
/// Arhitectura: Clean Architecture (Stratul Data - Modele de Date)
/// Punctul 4: Modele de date și serializarea/deserializarea JSON.
/// 
/// Descriere detaliată:
/// Acest fișier definește structurile de date (entitățile și modelele) utilizate
/// în aplicația medicală pentru a mapa răspunsurile primite de la serverul REST API
/// (endpoint-urile feed și details) și din fișierele locale JSON. Conține constructorii
/// `fromJson` pentru deserializare și metodele `toJson` pentru serializare.
/// ============================================================================

export '../models/appointment_data_model.dart';

/// Modelul de date pentru elementele de tip Feed prelucrate de la serverul REST API.
/// Corespunde endpoint-ului: https://test-api-jlbn.onrender.com/lab2026/v2/feed
class ModelFeedApi {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  const ModelFeedApi({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  /// Deserializare JSON: Convertește un Map dinamic primit de la API într-un obiect [ModelFeedApi].
  /// Include verificări de nule și conversii sigure de tip.
  factory ModelFeedApi.fromJson(Map<String, dynamic> json) {
    return ModelFeedApi(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
    );
  }

  /// Serializare JSON: Convertește obiectul [ModelFeedApi] înapoi într-un Map pentru trimitere sau stocare.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}

/// Modelul de date pentru detaliile extinse preluate de la serverul REST API.
/// Corespunde endpoint-ului: https://test-api-jlbn.onrender.com/lab2026/v2/feed/details
class ModelDetaliiApi {
  final String id;
  final String detailsInfo;
  final String author;
  final double rating;

  const ModelDetaliiApi({
    required this.id,
    required this.detailsInfo,
    required this.author,
    required this.rating,
  });

  /// Deserializare JSON: Convertește răspunsul JSON de detalii într-un obiect [ModelDetaliiApi].
  factory ModelDetaliiApi.fromJson(Map<String, dynamic> json) {
    return ModelDetaliiApi(
      id: json['id']?.toString() ?? '',
      detailsInfo: json['detailsInfo']?.toString() ?? json['info']?.toString() ?? '',
      author: json['author']?.toString() ?? 'Specialist Medical',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
    );
  }

  /// Serializare JSON: Convertește obiectul [ModelDetaliiApi] în format Map<String, dynamic>.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'detailsInfo': detailsInfo,
      'author': author,
      'rating': rating,
    };
  }
}
