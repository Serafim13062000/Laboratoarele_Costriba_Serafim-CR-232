import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/medical_cubit.dart';
import 'repositories/medical_repository.dart';
import 'views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MedicalRepository(),
      child: BlocProvider(
        create: (context) =>
        MedicalCubit(context.read<MedicalRepository>())..fetchAppData(),
        child: MaterialApp(
          title: 'Medical Appointment',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF1396AA),
            scaffoldBackgroundColor: const Color(0xFFFAFAFA),
            useMaterial3: true,
          ),
          home: const HomeView(),
        ),
      ),
    );
  }
}