/// ============================================================================
/// Fișierul: calcule_logica_medicala.dart
/// Arhitectura: Clean Architecture (Stratul Domain - Logică de Business & Calcule)
/// Punctul 2 (Partea de Domain): Reguli de afaceri și procesare date.
/// 
/// Descriere detaliată:
/// Acest fișier conține logica pură de business, independentă de UI sau sursele de date.
/// Implementează algoritmi pentru:
/// - Filtrarea listei de doctori după termenul de căutare introdus de utilizator.
/// - Filtrarea pe baza specialităților sau categoriilor medicale (ex. stomatologie, ochi, etc.).
/// - Criterii de sortare alfabetică sau după distanță.
/// - Gestionarea elementelor favorite.
/// ============================================================================

import 'modele_date_medicale.dart';

/// Enumerație care definește criteriile de sortare posibile pentru lista de doctori
enum CriteriuSortareDoctori {
  niciunul,
  dupaNume,
  dupaDistanta,
}

class CalculeLogicaMedicala {
  /// Procesează și filtrează lista de doctori pe baza mai multor criterii simultane:
  /// - `doctoriInitiali`: Lista de start.
  /// - `termenCautare`: Textul introdus în bara de căutare.
  /// - `categorieSelectata`: Categoria de specialitate medicală selectată.
  /// - `criteriuSortare`: Criteriul de ordonare a rezultatelor.
  /// - `doarFavorite`: Dacă se afișează doar doctorii marcați ca favoriti.
  static List<DoctorModel> proceseazaListaDoctori({
    required List<DoctorModel> doctoriInitiali,
    required String termenCautare,
    required String categorieSelectata,
    required CriteriuSortareDoctori criteriuSortare,
    required bool doarFavorite,
  }) {
    List<DoctorModel> rezultat = List.from(doctoriInitiali);

    // 1. Aplicare filtru pentru doctori favoriti
    if (doarFavorite) {
      rezultat = rezultat.where((doctor) => doctor.isFavorite).toList();
    }

    // 2. Aplicare filtru după termenul de căutare (nume sau specialitate)
    if (termenCautare.trim().isNotEmpty) {
      final termen = termenCautare.toLowerCase();
      rezultat = rezultat.where((doctor) {
        return doctor.name.toLowerCase().contains(termen) ||
               doctor.specialty.toLowerCase().contains(termen);
      }).toList();
    }

    // 3. Aplicare filtru după categoria de servicii medicale selectate
    if (categorieSelectata != 'All') {
      final categorie = categorieSelectata.toLowerCase();
      rezultat = rezultat.where((doctor) {
        final specialitate = doctor.specialty.toLowerCase();
        if (categorie == 'tooth') {
          return specialitate.contains('dental') || specialitate.contains('tooth');
        }
        return specialitate.contains(categorie);
      }).toList();
    }

    // 4. Aplicare reguli de sortare (după nume sau distanță)
    if (criteriuSortare == CriteriuSortareDoctori.dupaNume) {
      rezultat.sort((a, b) => a.name.compareTo(b.name));
    } else if (criteriuSortare == CriteriuSortareDoctori.dupaDistanta) {
      rezultat.sort((a, b) => a.distance.compareTo(b.distance));
    }

    return rezultat;
  }
}
