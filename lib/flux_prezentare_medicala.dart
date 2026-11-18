/// ============================================================================
/// Fișierul: flux_prezentare_medicala.dart
/// Arhitectura: Clean Architecture (Stratul Presentation - Fluxul de date UI)
/// Punctul 7: Fluxul complet al datelor pregătit pentru prezentare.
/// 
/// Descriere detaliată:
/// Acest fișier acționează ca un widget orchestrator care ascultă stările emise
/// de [MedicalCubit] folosind `BlocBuilder`.
/// În funcție de starea curentă a aplicației, afișează interfața corespunzătoare:
/// - [MedicalLoading]: Indicatorul de încărcare.
/// - [MedicalNoInternet]: Ecranul de lipsă conexiune internet.
/// - [MedicalError] / [MedicalEmpty]: Ecrane de eroare sau stări goale cu opțiune de reîncercare.
/// - [MedicalLoaded]: Ecranul principal [HomeView] cu doctori, servicii și opțiuni.
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/medical_cubit.dart';
import 'cubit/medical_state.dart';
import 'interfata_utilizator_medicala.dart';

class FluxPrezentareMedicala extends StatelessWidget {
  const FluxPrezentareMedicala({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalCubit, MedicalState>(
      builder: (context, stare) {
        if (stare is MedicalLoading) {
          return const WidgetIncarcareMedicala();
        } else if (stare is MedicalNoInternet) {
          return NoInternetView(
            onRetry: () {
              context.read<MedicalCubit>().fetchAppData();
            },
          );
        } else if (stare is MedicalError) {
          return WidgetEroareMedicala(
            mesajEroare: stare.message,
            laReincarcare: () {
              context.read<MedicalCubit>().fetchAppData();
            },
          );
        } else if (stare is MedicalEmpty) {
          return WidgetEroareMedicala(
            mesajEroare: 'Nu există date medicale disponibile în prezent.',
            laReincarcare: () {
              context.read<MedicalCubit>().fetchAppData();
            },
          );
        } else if (stare is MedicalLoaded) {
          return const HomeView();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
