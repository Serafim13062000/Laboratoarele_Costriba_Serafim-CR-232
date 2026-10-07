import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/medical_cubit.dart';
import '../cubit/medical_state.dart';
import '../models/appointment_data_model.dart';
import '../widgets/doctor_tile.dart';
import '../widgets/no_internet_view.dart';
import 'appointment_details_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  IconData _getServiceIcon(String id) {
    switch (id) {
      case 'tooth':
        return Icons.cleaning_services_outlined;
      case 'eye':
        return Icons.remove_red_eye_outlined;
      case 'lungs':
        return Icons.air;
      case 'ear':
        return Icons.hearing;
      case 'heart':
        return Icons.favorite_border;
      case 'brain':
        return Icons.psychology_outlined;
      default:
        return Icons.medical_services_outlined;
    }
  }

  void _openFilterSortSheet(BuildContext context, MedicalLoaded state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalCtx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Opțiuni Filtrare & Sortare',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(modalCtx),
                  ),
                ],
              ),
              const Divider(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.favorite, color: Colors.redAccent),
                title: const Text('Afișează doar Favorite'),
                trailing: state.showOnlyFavorites
                    ? const Icon(Icons.check_circle, color: Color(0xFF1396AA))
                    : null,
                onTap: () {
                  Navigator.pop(modalCtx);
                  context.read<MedicalCubit>().toggleFavoritesOnly();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.sort_by_alpha, color: Color(0xFF1396AA)),
                title: const Text('Sortare alfabetică (A - Z)'),
                trailing: state.sortOption == DoctorSortOption.nameAsc
                    ? const Icon(Icons.check_circle, color: Color(0xFF1396AA))
                    : null,
                onTap: () {
                  Navigator.pop(modalCtx);
                  context.read<MedicalCubit>().toggleSort();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.near_me_outlined, color: Color(0xFF1396AA)),
                title: const Text('Sortare după distanță'),
                trailing: state.sortOption == DoctorSortOption.distanceAsc
                    ? const Icon(Icons.check_circle, color: Color(0xFF1396AA))
                    : null,
                onTap: () {
                  Navigator.pop(modalCtx);
                  context.read<MedicalCubit>().toggleSort();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.restart_alt, color: Colors.redAccent),
                title: const Text('Resetează toate filtrele și sortarea'),
                onTap: () {
                  Navigator.pop(modalCtx);
                  context.read<MedicalCubit>().filterByCategory('All');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: BlocBuilder<MedicalCubit, MedicalState>(
          builder: (context, state) {
            if (state is MedicalNoInternet) {
              return NoInternetView(
                onRetry: () => context.read<MedicalCubit>().fetchAppData(),
              );
            }

            if (state is MedicalLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1396AA)),
              );
            }

            if (state is MedicalError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<MedicalCubit>().fetchAppData(),
                      child: const Text('Reîncearcă'),
                    ),
                  ],
                ),
              );
            }

            if (state is MedicalEmpty) {
              return const Center(child: Text('Nu există date disponibile.'));
            }

            final loaded = state as MedicalLoaded;
            final user = loaded.rawData['homeScreen']['user'];
            final appointment = loaded.rawData['homeScreen']['appointment'];

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                // Header Profil & Notificări
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(user['avatarUrl']),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['greeting'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              user['subtitle'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none, size: 28),
                          onPressed: () {},
                        ),
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Căutare + Buton Filtru / Meniu
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          onChanged: (val) =>
                              context.read<MedicalCubit>().searchDoctor(val),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            hintText: 'Search something',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: (loaded.sortOption != DoctorSortOption.none ||
                            loaded.showOnlyFavorites)
                            ? const Color(0xFF1396AA)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.tune,
                          color: (loaded.sortOption != DoctorSortOption.none ||
                              loaded.showOnlyFavorites)
                              ? Colors.white
                              : Colors.black87,
                        ),
                        tooltip: 'Opțiuni Filtru și Sortare',
                        onPressed: () => _openFilterSortSheet(context, loaded),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Card Programare (Hero Card)
                InkWell(
                  onTap: () {
                    final apptDoctor = DoctorModel(
                      id: 'appointment-hero',
                      name: appointment['doctor']['name'],
                      specialty: appointment['doctor']['specialty'],
                      avatarUrl: appointment['doctor']['avatarUrl'],
                      distance: 'Current appointment',
                      isFavorite: false,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppointmentDetailsView(
                          selectedDoctor: apptDoctor,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1396AA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appointment['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month,
                                color: Colors.white70, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              appointment['date'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: Colors.white70, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              appointment['time'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  appointment['doctor']['avatarUrl'],
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 44,
                                    height: 44,
                                    color: const Color(0xFFF3F4F6),
                                    child: const Icon(Icons.person, color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appointment['doctor']['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      appointment['doctor']['specialty'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chat_bubble_outline),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Health Services (Scrollabil orizontal)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Health Services',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () =>
                          context.read<MedicalCubit>().filterByCategory('All'),
                      child: const Text(
                        'Reset/All',
                        style: TextStyle(color: Color(0xFF1396AA)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 98,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: loaded.services.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final s = loaded.services[index];
                      final isSelected = loaded.selectedCategory == s.id;
                      return GestureDetector(
                        onTap: () =>
                            context.read<MedicalCubit>().filterByCategory(s.id),
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1396AA)
                                    : const Color(0xFFF6F8FA),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1396AA)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                _getServiceIcon(s.id),
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF1396AA),
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              s.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? const Color(0xFF1396AA)
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Nearby Doctor Header cu Toggle pentru Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loaded.showOnlyFavorites
                          ? 'Favorite Doctors'
                          : 'Nearby Doctor',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          context.read<MedicalCubit>().toggleFavoritesOnly(),
                      child: Text(
                        loaded.showOnlyFavorites
                            ? 'Show All'
                            : 'Only Favorites',
                        style: const TextStyle(color: Color(0xFF1396AA)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Lista de medici
                if (loaded.filteredDoctors.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Text(
                      loaded.showOnlyFavorites
                          ? 'Nu aveți niciun medic salvat la favorite.'
                          : 'Niciun medic găsit pentru criteriile selectate.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                else
                  ...loaded.filteredDoctors.map(
                        (doc) => DoctorTile(
                      doctor: doc,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AppointmentDetailsView(
                              selectedDoctor: doc,
                            ),
                          ),
                        );
                      },
                      onFavoriteTap: () {
                        context.read<MedicalCubit>().toggleFavorite(doc.id);
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}