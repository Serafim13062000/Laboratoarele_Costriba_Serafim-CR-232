import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/medical_cubit.dart';
import '../cubit/medical_state.dart';
import '../models/appointment_data_model.dart';

class AppointmentDetailsView extends StatelessWidget {
  final DoctorModel? selectedDoctor;

  const AppointmentDetailsView({super.key, this.selectedDoctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Appointment',
          style: TextStyle(
            color: Color(0xFF1396AA),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<MedicalCubit, MedicalState>(
        builder: (context, state) {
          if (state is! MedicalLoaded) return const SizedBox();

          final details = state.rawData['appointmentDetails'];
          final defaultDoctor = details['doctor'];
          final payment = details['payment'];
          final desc = details['details']['description'];
          final hours = details['workingHours']['slots'] as List;
          final dates = details['date']['slots'] as List;

          final doctorName = selectedDoctor?.name ?? defaultDoctor['name'];
          final doctorClinic = selectedDoctor != null
              ? selectedDoctor!.specialty
              : defaultDoctor['clinic'];
          final doctorAvatar =
              selectedDoctor?.avatarUrl ?? defaultDoctor['avatarUrl'];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Detalii Doctor
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        doctorAvatar,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 90,
                          height: 90,
                          color: Colors.grey[200],
                          child: const Icon(Icons.person, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  doctorName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.chat_bubble_outline,
                                      size: 20,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.phone_outlined,
                                      size: 20,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.videocam_outlined,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            doctorClinic,
                            style: const TextStyle(
                              color: Color(0xFF1396AA),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Payment',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                payment['formatted'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF1396AA),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Descriere
                const Text(
                  'Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.grey[600],
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),

                // Working Hours
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Working Hours',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  children: hours.map((slot) {
                    final isSelected = state.selectedHourId == slot['id'];
                    return ChoiceChip(
                      label: Text(slot['label']),
                      selected: isSelected,
                      selectedColor: const Color(0xFF1396AA),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      backgroundColor: const Color(0xFFF3F4F6),
                      onSelected: (_) =>
                          context.read<MedicalCubit>().selectHour(slot['id']),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  children: dates.map((slot) {
                    final isSelected = state.selectedDateId == slot['id'];
                    return ChoiceChip(
                      label: Text(slot['label']),
                      selected: isSelected,
                      selectedColor: const Color(0xFF1396AA),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      backgroundColor: const Color(0xFFF3F4F6),
                      onSelected: (_) =>
                          context.read<MedicalCubit>().selectDate(slot['id']),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 36),

                // Buton Book Appointment
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1396AA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Programare la $doctorName rezervată cu succes!',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      details['actions']['bookAppointment']['label'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}