/// ============================================================================
/// Fișierul: medical_state.dart
/// Arhitectura: Clean Architecture (Stratul Presentation - Stările aplicației)
/// Punctul 5: Gestionarea stărilor asincrone, a încărcării și a erorilor.
/// 
/// Descriere detaliată:
/// Acest fișier definește ierarhia de stări imutabile pentru aplicația medicală
/// utilizând pachetul `equatable` pentru comparații eficiente:
/// - [MedicalLoading]: Starea afișată în timpul cererilor asincrone de rețea.
/// - [MedicalNoInternet]: Starea detectată automat când conexiunea la internet lipsește.
/// - [MedicalError]: Starea activată în cazul unor erori de server sau excepții.
/// - [MedicalEmpty]: Starea când datele returnate sunt goale.
/// - [MedicalLoaded]: Starea de succes care conține datele, listele de doctori și servicii.
/// ============================================================================

import 'package:equatable/equatable.dart';
import '../models/appointment_data_model.dart';

enum DoctorSortOption { none, nameAsc, distanceAsc }

abstract class MedicalState extends Equatable {
  const MedicalState();

  @override
  List<Object?> get props => [];
}

/// Stare de încărcare asincronă (afișează indicator circular)
class MedicalLoading extends MedicalState {}

/// Stare de lipsă conexiune internet (monitorizată prin connectivity_plus)
class MedicalNoInternet extends MedicalState {}

/// Stare de eroare în cazul eșecului cererilor HTTP sau parsării
class MedicalError extends MedicalState {
  final String message;
  const MedicalError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Stare când nu există rezultate/doctori disponibili
class MedicalEmpty extends MedicalState {}

/// Stare de succes care conține întregul set de date încărcate și filtrate
class MedicalLoaded extends MedicalState {
  final Map<String, dynamic> rawData;
  final List<DoctorModel> allDoctors;
  final List<DoctorModel> filteredDoctors;
  final List<HealthService> services;
  final String searchQuery;
  final String selectedCategory;
  final DoctorSortOption sortOption;
  final bool showOnlyFavorites;
  final String? selectedDateId;
  final String? selectedHourId;

  const MedicalLoaded({
    required this.rawData,
    required this.allDoctors,
    required this.filteredDoctors,
    required this.services,
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.sortOption = DoctorSortOption.none,
    this.showOnlyFavorites = false,
    this.selectedDateId,
    this.selectedHourId,
  });

  /// Creează o copie a stării curente actualizând doar câmpurile modificate (Imutabilitate)
  MedicalLoaded copyWith({
    List<DoctorModel>? allDoctors,
    List<DoctorModel>? filteredDoctors,
    String? searchQuery,
    String? selectedCategory,
    DoctorSortOption? sortOption,
    bool? showOnlyFavorites,
    String? selectedDateId,
    String? selectedHourId,
  }) {
    return MedicalLoaded(
      rawData: rawData,
      allDoctors: allDoctors ?? this.allDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      services: services,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sortOption: sortOption ?? this.sortOption,
      showOnlyFavorites: showOnlyFavorites ?? this.showOnlyFavorites,
      selectedDateId: selectedDateId ?? this.selectedDateId,
      selectedHourId: selectedHourId ?? this.selectedHourId,
    );
  }

  @override
  List<Object?> get props => [
        rawData,
        allDoctors,
        filteredDoctors,
        services,
        searchQuery,
        selectedCategory,
        sortOption,
        showOnlyFavorites,
        selectedDateId,
        selectedHourId,
      ];
}
