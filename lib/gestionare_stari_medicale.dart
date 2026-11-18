// Fișierul: gestionare_stari_medicale.dart
// Punctul 5: Gestionarea stărilor asincrone, a încărcării, a erorilor și a conexiunii de internet.
// Conține definiția stărilor aplicației medicale (MedicalState, MedicalLoading, MedicalLoaded, etc.)
// și clasa MedicalCubit care coordonează logica asincronă, conexiunea de rețea și API-ul.

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modele_date_medicale.dart';
import 'repository_comunicare_medicala.dart';
import 'calcule_logica_medicala.dart';

// Opțiuni de sortare pentru doctori
enum DoctorSortOption { none, nameAsc, distanceAsc }

// Clasele de bază pentru stările aplicației medicale
abstract class MedicalState extends Equatable {
  const MedicalState();

  @override
  List<Object?> get props => [];
}

class MedicalLoading extends MedicalState {}

class MedicalNoInternet extends MedicalState {}

class MedicalError extends MedicalState {
  final String message;
  const MedicalError(this.message);

  @override
  List<Object?> get props => [message];
}

class MedicalEmpty extends MedicalState {}

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

// Cubit-ul principal pentru gestionarea stărilor asincrone și a interacțiunilor
class MedicalCubit extends Cubit<MedicalState> {
  final RepositoryComunicareMedicala repository;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  MedicalCubit(this.repository) : super(MedicalLoading()) {
    _monitorConnectivity();
    fetchAppData();
  }

  // Monitorizarea conexiunii la internet în timp real
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

  // Preluarea asincronă a datelor (inclusiv integrare API feed & details)
  Future<void> fetchAppData() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      emit(MedicalNoInternet());
      return;
    }

    emit(MedicalLoading());
    try {
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

  // Preluarea detaliilor specifice din API (feed/details)
  Future<ModelDetaliiApi?> preiaDetaliiApiSpecifice({String? id}) async {
    try {
      return await repository.obtineDetaliiApi(id: id);
    } catch (_) {
      return null;
    }
  }

  void searchDoctor(String query) {
    if (state is! MedicalLoaded) return;
    final current = state as MedicalLoaded;
    _applyFiltersAndSort(query, current.selectedCategory, current.sortOption);
  }

  void filterByCategory(String categoryId) {
    if (state is! MedicalLoaded) return;
    final current = state as MedicalLoaded;
    final newCategory =
        current.selectedCategory == categoryId ? 'All' : categoryId;
    _applyFiltersAndSort(current.searchQuery, newCategory, current.sortOption);
  }

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

  void selectDate(String slotId) {
    if (state is! MedicalLoaded) return;
    emit((state as MedicalLoaded).copyWith(selectedDateId: slotId));
  }

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
