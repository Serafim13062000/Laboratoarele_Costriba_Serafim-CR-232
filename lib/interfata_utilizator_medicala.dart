/// ============================================================================
/// Fișierul: interfata_utilizator_medicala.dart
/// Arhitectura: Clean Architecture (Stratul Presentation - Componente UI Reutilizabile)
/// Punctul 6: UI reutilizabil adaptat după designul existent.
/// 
/// Descriere detaliată:
/// Acest fișier centralizează și exportă componentele vizuale reutilizabile ale aplicației:
/// - Ecranul principal ([HomeView]) și ecranul de detalii ([AppointmentDetailsView]).
/// - Widget-uri pentru carduri de doctori și stări de eroare/încărcare.
/// Toate componentele respectă designul system-ului medical.
/// ============================================================================

import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'views/appointment_details_view.dart';
import 'widgets/doctor_tile.dart';
import 'widgets/no_internet_view.dart';

// Exportă ecranele și widget-urile pentru a fi utilizate în fluxul de prezentare
export 'views/home_view.dart';
export 'views/appointment_details_view.dart';
export 'widgets/doctor_tile.dart';
export 'widgets/no_internet_view.dart';

/// Widget reutilizabil pentru afișarea stării de încărcare în stilul aplicației medicale
class WidgetIncarcareMedicala extends StatelessWidget {
  const WidgetIncarcareMedicala({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1396AA)),
        ),
      ),
    );
  }
}

/// Widget reutilizabil pentru afișarea erorilor în interfață cu buton de reîncercare
class WidgetEroareMedicala extends StatelessWidget {
  final String mesajEroare;
  final VoidCallback laReincarcare;

  const WidgetEroareMedicala({
    super.key,
    required this.mesajEroare,
    required this.laReincarcare,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.medical_services_outlined, size: 64, color: Color(0xFF1396AA)),
              const SizedBox(height: 16),
              const Text(
                'Eroare Sistem Medical',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                mesajEroare,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1396AA),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: laReincarcare,
                icon: const Icon(Icons.refresh),
                label: const Text('Reîncearcă'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
