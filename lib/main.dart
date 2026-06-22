import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/loan_form_cubit.dart';
import 'screens/loan_application_form_screen.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => LoanFormCubit(),
      child: const LoanApplicationApp(),
    ),
  );
}

class LoanApplicationApp extends StatelessWidget {
  const LoanApplicationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B3D91)),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDC2626)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDC2626), width: 2),
          ),
          errorStyle: const TextStyle(
            color: Color(0xFFDC2626),
            fontSize: 12,
            height: 1.3,
          ),
          errorMaxLines: 2,
        ),
      ),
      home: const LoanApplicationFormScreen(),
    );
  }
}
