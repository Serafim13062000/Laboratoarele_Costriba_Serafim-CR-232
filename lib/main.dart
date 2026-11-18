/// ============================================================================
/// Fișierul: main.dart
/// Fișierul central (Entry Point) al aplicației.
/// 
/// Descriere detaliată:
/// Ac Acesta este punctului central de pornire a aplicației Flutter.
/// Configurează corect Dependency Injection prin:
/// - [RepositoryProvider]: Oferă instanța de [RepositoryComunicareMedicala] (Stratul Data).
/// - [BlocProvider]: Oferă instanța de [MedicalCubit] (Stratul Presentation).
/// - [MaterialApp]: Lansează [FluxPrezentareMedicala] care coordonează fluxul complet al datelor.
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository_comunicare_medicala.dart';
import 'cubit/medical_cubit.dart';
import 'flux_prezentare_medicala.dart';

void main() {
  // Asigură inițializarea legăturilor widget-urilor Flutter înainte de executare
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Inițializarea globală a Repository-ului de comunicare (Stratul Data)
        RepositoryProvider<RepositoryComunicareMedicala>(
          create: (context) => RepositoryComunicareMedicala(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Inițializarea Cubit-ului medical care gestionează stările și datele asincrone
          BlocProvider<MedicalCubit>(
            create: (context) => MedicalCubit(
              context.read<RepositoryComunicareMedicala>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Medical Appointment App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF1396AA),
            scaffoldBackgroundColor: const Color(0xFFFAFAFA),
            useMaterial3: true,
          ),
          // Apelarea fluxului complet de prezentare medicală ca ecran rădăcină
          home: const FluxPrezentareMedicala(),
        ),
      ),
    );
  }
}
