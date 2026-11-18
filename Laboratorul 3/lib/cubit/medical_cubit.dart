import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/appointment_data_model.dart';
import '../repositories/medical_repository.dart';
import 'medical_state.dart';

class MedicalCubit extends Cubit<MedicalState> {
  final MedicalRepository repository;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  MedicalCubit(this.repository) : super(MedicalLoading()) {
    _monitorConnectivity();
  }

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

  Future<void> fetchAppData() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      emit(MedicalNoInternet());
      return;
    }

    emit(MedicalLoading());
    try {
      final json = await repository.loadMedicalData();
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

    if (sort == DoctorSortOption.nameAsc) {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (sort == DoctorSortOption.distanceAsc) {
      list.sort((a, b) => a.distance.compareTo(b.distance));
    }

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