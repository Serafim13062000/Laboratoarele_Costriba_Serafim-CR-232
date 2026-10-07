import 'package:equatable/equatable.dart';
import '../models/appointment_data_model.dart';

enum DoctorSortOption { none, nameAsc, distanceAsc }

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