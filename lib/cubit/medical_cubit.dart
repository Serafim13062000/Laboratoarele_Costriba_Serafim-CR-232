/// ============================================================================
/// Fișierul: medical_cubit.dart
/// Arhitectura: Clean Architecture (Stratul Presentation - Gestionarea Stărilor și Logică UI)
/// Punctul 5 & 7: Gestionarea stărilor asincrone, a încărcării, a erorilor și a fluxului de date.
/// 
/// Descriere detaliată:
/// Acest fișier implementează [MedicalCubit] folosind biblioteca `flutter_bloc`.
/// Răspunde de:
/// - Coordonarea cererilor asincrone prin [RepositoryComunicareMedicala].
/// - Monitorizarea permanentă a stării conexiunii la internet (prin `connectivity_plus`).
/// - Aplicarea filtrelor, căutărilor și sortărilor apelând regulile din [CalculeLogicaMedicala].
/// - Emiterea stărilor corespunzătoare ([MedicalLoading], [MedicalLoaded], [MedicalError], etc.) către interfață.
/// ============================================================================

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/appointment_data_model.dart';
import '../repository_comunicare_medicala.dart';
import '../calcule_logica_medicala.dart';
import 'medical_state.dart';

class MedicalCubit extends Cubit<MedicalState> {
  final RepositoryComunicareMedicala repository;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  MedicalCubit(this.repository) : super(MedicalLoading()) {
    _monitorConnectivity();
    fetchAppData();
  }

  /// Monitorizează în timp real schimbările conexiunii de rețea.
  /// Dacă se pierde conexiunea, emite [MedicalNoInternet]; la reconectare, reîncarcă datele.
  void _monitorConnectivity() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.none)) {
        emit(MedicalNoInternet());
      } else {
        if (state is MedicalNoInternet) {
          fetchAppData();
        }
      }
    });
  }

  /// Metodă asincronă pentru preluarea datelor aplicației.
  /// Verifică conexiunea, emite starea de încărcare [MedicalLoading], preia datele
  /// din repository și emite starea de succes [MedicalLoaded] sau de eroare [MedicalError].
  Future<void> fetchAppData() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      emit(MedicalNoInternet());
      return;
    }

    emit(MedicalLoading());
    try {
      // Preluare date prin Repository-ul de comunicare (care integrează API și date locale)
      final json = await repository.incarcaDateMedicaleComplexe();
      final homeJson = json['homeScreen'] as Map<String, dynamic>;

      final rawDoctors = (homeJson['nearbyDoctors'] as List? ?? [])
          .map((item) => DoctorModel.fromJson(item))
          .toList();

      final services = (homeJson['healthServices'] as List? ?? [])
          .map((item) => HealthService.fromJson(item))
          .toList();

      if (rawDoctors.isEmpty) {
        emit(MedicalEmpty());
        return;
      }

      emit(MedicalLoaded(
        rawData: json,
        allDoctors: rawDoctors,
        filteredDoctors: rawDoctors,
        services: services,
        selectedDateId: 'sun-4',
        selectedHourId: '11am',
        showOnlyFavorites: false,
      ));
    } catch (e) {
      emit(MedicalError(e.toString()));
    }
  }

  /// Filtrează doctorii pe baza textului introdus în bara de căutare.
  void searchDoctor(String query) {
    if (state is! MedicalLoaded) return;
    final current = state as MedicalLoaded;
    _applyFiltersAndSort(query, current.selectedCategory, current.sortOption);
  }

  /// Filtrează doctorii pe baza categoriei de servicii medicale selectate.
  void filterByCategory(String categoryId) {
    if (state is! MedicalLoaded) return;
    final current = state as MedicalLoaded;
    final newCategory =
        current.selectedCategory == categoryId ? 'All' : categoryId;
    _applyFiltersAndSort(current.searchQuery, newCategory, current.sortOption);
  }

  /// Comută opțiunile de sortare (după nume, distanță sau fără sortare).
  void toggleSort() {
    if (state is! MedicalLoaded) return;
    final current = state as MedicalLoaded;
    DoctorSortOption nextSort;
    if (current.sortOption == DoctorSortOption.none) {
      nextSort = DoctorSortOption.nameAsc;
    } else if (current.sortOption == DoctorSortOption.nameAsc) {
      nextSort = DoctorSortOption.distanceAsc;
    } else {
      nextSort = DoctorSortOption.none;
    }
    _applyFiltersAndSort(current.searchQuery, current.selectedCategory, nextSort);
  }

  /// Comută vizualizarea exclusivă a doctorilor favoriti.
  void toggleFavoritesOnly() {
    if (state is! MedicalLoaded) return;
    final current = state as MedicalLoaded;
    final newFavOnly = !current.showOnlyFavorites;
    _applyFiltersAndSort(
      current.searchQuery,
      current.selectedCategory,
      current.sortOption,
      showOnlyFavs: newFavOnly,
    );
  }

  /// Marchează sau deselectează un doctor ca favorit după ID.
  void toggleFavorite(String doctorId) {
    if (state is! MedicalLoaded) return;
    final current = state as MedicalLoaded;

    final updatedAll = current.allDoctors.map((doc) {
      if (doc.id == doctorId) {
        return doc.copyWith(isFavorite: !doc.isFavorite);
      }
      return doc;
    }).toList();

    final updatedState = current.copyWith(allDoctors: updatedAll);
    emit(updatedState);

    _applyFiltersAndSort(
      updatedState.searchQuery,
      updatedState.selectedCategory,
      updatedState.sortOption,
      showOnlyFavs: updatedState.showOnlyFavorites,
    );
  }

  /// Metodă internă care aplică filtrele și sortările apelând stratul Domain ([CalculeLogicaMedicala]).
  void _applyFiltersAndSort(
      String query,
      String category,
      DoctorSortOption sort, {
        bool? showOnlyFavs,
      }) {
    final current = state as MedicalLoaded;
    final favOnly = showOnlyFavs ?? current.showOnlyFavorites;
    List<DoctorModel> list = List.from(current.allDoctors);

    if (favOnly) {
      list = list.where((d) => d.isFavorite).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((d) {
        return d.name.toLowerCase().contains(q) ||
            d.specialty.toLowerCase().contains(q);
      }).toList();
    }

    if (category != 'All') {
      final cat = category.toLowerCase();
      list = list.where((d) {
        final spec = d.specialty.toLowerCase();
        if (cat == 'tooth') return spec.contains('dental') || spec.contains('tooth');
        return spec.contains(cat);
      }).toList();
    }

    final criteriu = sort == DoctorSortOption.nameAsc
        ? CriteriuSortareDoctori.dupaNume
        : sort == DoctorSortOption.distanceAsc
            ? CriteriuSortareDoctori.dupaDistanta
            : CriteriuSortareDoctori.niciunul;

    list = CalculeLogicaMedicala.proceseazaListaDoctori(
      doctoriInitiali: list,
      termenCautare: query,
      categorieSelectata: category,
      criteriuSortare: criteriu,
      doarFavorite: false,
    );

    emit(current.copyWith(
      searchQuery: query,
      selectedCategory: category,
      sortOption: sort,
      showOnlyFavorites: favOnly,
      filteredDoctors: list,
    ));
  }

  /// Selectează data programării în interfață.
  void selectDate(String slotId) {
    if (state is! MedicalLoaded) return;
    emit((state as MedicalLoaded).copyWith(selectedDateId: slotId));
  }

  /// Selectează ora programării în interfață.
  void selectHour(String slotId) {
    if (state is! MedicalLoaded) return;
    emit((state as MedicalLoaded).copyWith(selectedHourId: slotId));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
