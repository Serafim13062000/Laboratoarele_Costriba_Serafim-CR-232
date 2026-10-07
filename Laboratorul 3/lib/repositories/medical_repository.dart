import 'dart:convert';
import 'package:flutter/services.dart';

class MedicalRepository {
  Future<Map<String, dynamic>> loadMedicalData() async {
    // Simulare de latență asincronă pentru a observa starea Loading
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      final jsonString =
      await rootBundle.loadString('assets/data/medical_data.json');
      final data = json.decode(jsonString);
      return data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Eroare la citirea datelor JSON: $e');
    }
  }
}