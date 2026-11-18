import 'package:flutter/material.dart';

void main() {
  runApp(const DoctorAppointmentApp());
}

class DoctorAppointmentApp extends StatelessWidget {
  const DoctorAppointmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor Appointment App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9FBFB),
        fontFamily: 'sans-serif',
        primaryColor: const Color(0xFF0E8FA9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E8FA9),
          primary: const Color(0xFF0E8FA9),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class Doctor {
  final String name;
  final String specialty;
  final String location;
  final String imageUrl;

  const Doctor({
    required this.name,
    required this.specialty,
    required this.location,
    required this.imageUrl,
  });
}

// -------------------------------------------------------------
// 1. HOMESCREEN
// -------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double doctorCardHeight = 76.0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, Jonathan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'May you always be healthy',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: -0.1,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _NotificationBadge(),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              const _SearchBar(),
              const SizedBox(height: 22),

              // Banner cu Programarea Activă
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Containerul Teal
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 56),
                    decoration: BoxDecoration(
                      color: const Color(0xFF169EB5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titlu Appointment + Săgeată
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Appointment',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                letterSpacing: 0.1,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 13,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Dată, Oră și Butonul Edit
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '22 October, 2023',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.1,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '08:00 AM - 10.30 AM',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: 38,
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.45),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Cardul alb suprapus (centrat și simetric)
                  Positioned(
                    bottom: -doctorCardHeight / 2,
                    left: 16,
                    right: 16,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const AppointmentDetailScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        height: doctorCardHeight,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=150',
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 48,
                                      height: 48,
                                      color: const Color(0xFFE2E8F0),
                                      child: const Icon(
                                        Icons.person,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Dr. Richar Kandowen',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.5,
                                      letterSpacing: -0.2,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Child Specialist',
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 11.5,
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Color(0xFF64748B),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: doctorCardHeight / 2 + 24),

              // Health Services
              _SectionHeader(title: 'Health Services', onPressed: () {}),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _ServiceItem(emoji: '🦷', label: 'Tooth'),
                  _ServiceItem(emoji: '👁️', label: 'Eye'),
                  _ServiceItem(emoji: '🫁', label: 'Lungs'),
                  _ServiceItem(emoji: '👂', label: 'Ear'),
                ],
              ),
              const SizedBox(height: 22),

              // Nearby Doctor
              _SectionHeader(title: 'Nearby Doctor', onPressed: () {}),
              const SizedBox(height: 8),

              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: nearbyDoctors.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final doctor = nearbyDoctors[index];
                  return _DoctorListTile(
                    doctor: doctor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const AppointmentDetailScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. APPOINTMENT DETAILS SCREEN
// -------------------------------------------------------------
class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF1E293B),
                      size: 20,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Appointment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: Color(0xFF169EB5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 24),

              // Doctor Profile Card
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=200',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 90,
                        height: 90,
                        color: const Color(0xFFE2E8F0),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Dr.Upul',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.2,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Spacer(),
                            _ActionIcon(icon: Icons.chat_bubble_outline_rounded),
                            SizedBox(width: 6),
                            _ActionIcon(icon: Icons.phone_outlined),
                            SizedBox(width: 6),
                            _ActionIcon(icon: Icons.videocam_outlined),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Denteeth',
                          style: TextStyle(
                            color: Color(0xFF64B5C6),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.1,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Payment',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: -0.2,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              '\$120.00',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: -0.2,
                                color: Color(0xFF169EB5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Worem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur tempus urna at turpis condimentum lobortis. Ut commodo efficitur neque. Ut diam quam, semper iaculis condimentum ac, vestibulum eu nisl.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                  height: 1.5,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 24),

              _SectionHeader(title: 'Working Hours', onPressed: () {}),
              const SizedBox(height: 10),
              Row(
                children: const [
                  _SelectableChip(title: '10.00 AM', isSelected: false),
                  SizedBox(width: 10),
                  _SelectableChip(title: '11.00 AM', isSelected: true),
                  SizedBox(width: 10),
                  _SelectableChip(title: '12.00 PM', isSelected: false),
                ],
              ),
              const SizedBox(height: 24),

              _SectionHeader(title: 'Date', onPressed: () {}),
              const SizedBox(height: 10),
              Row(
                children: const [
                  _SelectableChip(title: 'Sun 4', isSelected: true),
                  SizedBox(width: 10),
                  _SelectableChip(title: 'Mon 5', isSelected: false),
                  SizedBox(width: 10),
                  _SelectableChip(title: 'Tue 6', isSelected: false),
                ],
              ),
              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF169EB5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Appointment Booked Successfully!'),
                      ),
                    );
                  },
                  child: const Text(
                    'Book an Appointment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// UI HELPERS
// -------------------------------------------------------------
class _NotificationBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF1E293B),
            size: 24,
          ),
          Positioned(
            right: 1,
            top: 1,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF94A3B8), size: 22),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Search something',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
                letterSpacing: -0.1,
              ),
            ),
          ),
          Icon(Icons.tune_rounded, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _SectionHeader({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
            color: Color(0xFF1E293B),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'See All',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF169EB5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final String emoji;
  final String label;

  const _ServiceItem({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F8F9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 26)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

class _DoctorListTile extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onTap;

  const _DoctorListTile({required this.doctor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE2E8F0),
              backgroundImage: NetworkImage(doctor.imageUrl),
              onBackgroundImageError: (exception, stackTrace) {},
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: -0.2,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    doctor.specialty,
                    style: const TextStyle(
                      fontSize: 12,
                      letterSpacing: -0.1,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF169EB5),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          doctor.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            letterSpacing: -0.1,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.favorite_border_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;

  const _ActionIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16, color: const Color(0xFF475569)),
    );
  }
}

class _SelectableChip extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _SelectableChip({required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF169EB5) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

const List<Doctor> nearbyDoctors = [
  Doctor(
    name: 'Dr. Emmly Lestiryno',
    specialty: 'General Practitioner',
    location: '3167 Durgan Shores - 500M from you',
    imageUrl:
    'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=150',
  ),
  Doctor(
    name: 'Dr. Sonja Littel',
    specialty: 'Dental Specialist',
    location: '950 Sigrid Port - 753M from you',
    imageUrl:
    'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=150',
  ),
];