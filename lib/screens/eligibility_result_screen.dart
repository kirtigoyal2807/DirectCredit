import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/loan_form_cubit.dart';
import '../cubit/loan_form_state.dart';

class EligibilityResultScreen extends StatefulWidget {
  const EligibilityResultScreen({super.key});

  @override
  State<EligibilityResultScreen> createState() => _EligibilityResultScreenState();
}

class _EligibilityResultScreenState extends State<EligibilityResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showDetailsDialog());
  }

  String _formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  void _showDetailsDialog() {
    final state = context.read<LoanFormCubit>().state;
    final app = state.application;
    final result = state.eligibilityResult;

    if (app == null || result == null) {
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(
              result.isEligible ? Icons.check_circle : Icons.cancel,
              color: result.isEligible
                  ? const Color(0xFF00A86B)
                  : const Color(0xFFDC2626),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                result.isEligible ? 'Eligible' : 'Not Eligible',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                result.message,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _DetailRow(label: 'Full Name', value: app.fullName),
              _DetailRow(
                label: 'Mobile Number',
                value: '+91 ${app.mobileNumber}',
              ),
              _DetailRow(
                label: 'Monthly Income',
                value: _formatAmount(app.monthlyIncome),
              ),
              _DetailRow(
                label: 'Existing EMI',
                value: _formatAmount(app.existingEmi),
              ),
              _DetailRow(
                label: 'Required Loan Amount',
                value: _formatAmount(app.requiredLoanAmount),
              ),
              _DetailRow(
                label: 'Disposable Income',
                value: _formatAmount(result.disposableIncome),
              ),
              _DetailRow(
                label: 'Max Eligible Loan',
                value: _formatAmount(result.maxEligibleLoan),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Back to Form'),
          ),
          if (result.isEligible)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Proceeding with loan application...'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B3D91),
                foregroundColor: Colors.white,
              ),
              child: const Text('Proceed'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoanFormCubit, LoanFormState>(
      builder: (context, state) {
        final result = state.eligibilityResult;

        if (result == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Eligibility Result'),
            backgroundColor: const Color(0xFF0B3D91),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    result.isEligible
                        ? Icons.verified_outlined
                        : Icons.info_outline,
                    size: 72,
                    color: result.isEligible
                        ? const Color(0xFF00A86B)
                        : const Color(0xFFDC2626),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    result.isEligible
                        ? 'You are eligible!'
                        : 'Not eligible at this time',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1F36),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    result.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: _showDetailsDialog,
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('View Details'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF1A1F36),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
