import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/loan_form_cubit.dart';
import '../cubit/loan_form_state.dart';
import '../validators/loan_form_validators.dart';
import 'eligibility_result_screen.dart';

class LoanApplicationFormScreen extends StatefulWidget {
  const LoanApplicationFormScreen({super.key});

  @override
  State<LoanApplicationFormScreen> createState() =>
      _LoanApplicationFormScreenState();
}

class _LoanApplicationFormScreenState extends State<LoanApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _monthlyIncomeController;
  late final TextEditingController _existingEmiController;
  late final TextEditingController _loanAmountController;

  static final _amountInputFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
  ];

  @override
  void initState() {
    super.initState();
    final form = context.read<LoanFormCubit>().state.form;
    _fullNameController = TextEditingController(text: form.fullName);
    _mobileController = TextEditingController(text: form.mobileNumber);
    _monthlyIncomeController = TextEditingController(text: form.monthlyIncome);
    _existingEmiController = TextEditingController(text: form.existingEmi);
    _loanAmountController =
        TextEditingController(text: form.requiredLoanAmount);


  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _monthlyIncomeController.dispose();
    _existingEmiController.dispose();
    _loanAmountController.dispose();
    super.dispose();
  }

  void _revalidateForm(LoanFormState state) {
    if (state.autovalidateMode == AutovalidateMode.onUserInteraction) {
      _formKey.currentState?.validate();
    }
  }

  Future<void> _checkEligibility() async {
    final cubit = context.read<LoanFormCubit>();
    cubit.enableAutoValidate();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await cubit.checkEligibility();

    if (!mounted || result == null) {
      return;
    }

    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const EligibilityResultScreen()),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    required void Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    List<TextInputFormatter>? inputFormatters,
    String? helperText,
    String? prefixText,
    int? maxLength,
    TextCapitalization textCapitalization = TextCapitalization.none,
    VoidCallback? onFieldSubmitted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        onFieldSubmitted:
            onFieldSubmitted != null ? (_) => onFieldSubmitted() : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          prefixText: prefixText,
          helperText: helperText,
          counterText: maxLength != null ? '' : null,
        ),
        maxLength: maxLength,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoanFormCubit, LoanFormState>(
      builder: (context, state) {
        final cubit = context.read<LoanFormCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Loan Application'),
            backgroundColor: const Color(0xFF0B3D91),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              autovalidateMode: state.autovalidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Apply for a Loan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1F36),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fill in your details to check loan eligibility.',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 24),
                  _buildField(
                    controller: _fullNameController,
                    label: 'Full Name *',
                    icon: Icons.person_outline,
                    textCapitalization: TextCapitalization.words,
                    validator: LoanFormValidators.fullName,
                    onChanged: (value) {
                      cubit.fullNameChanged(value);
                      _revalidateForm(state);
                    },
                  ),
                  _buildField(
                    controller: _mobileController,
                    label: 'Mobile Number *',
                    icon: Icons.phone_outlined,
                    prefixText: '+91 ',
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: LoanFormValidators.mobileNumber,
                    onChanged: (value) {
                      cubit.mobileNumberChanged(value);
                      _revalidateForm(state);
                    },
                  ),
                  _buildField(
                    controller: _monthlyIncomeController,
                    label: 'Monthly Income (₹) *',
                    icon: Icons.currency_rupee,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: _amountInputFormatters,
                    validator: LoanFormValidators.monthlyIncome,
                    onChanged: (value) {
                      cubit.monthlyIncomeChanged(value);
                      _revalidateForm(state);
                    },
                  ),
                  _buildField(
                    controller: _existingEmiController,
                    label: 'Existing EMI (₹) *',
                    icon: Icons.payments_outlined,
                    helperText: 'Enter 0 if you have no existing EMIs',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: _amountInputFormatters,
                    validator: (value) => LoanFormValidators.existingEmi(
                      value,
                      monthlyIncomeValue: state.form.monthlyIncome,
                    ),
                    onChanged: (value) {
                      cubit.existingEmiChanged(value);
                      _revalidateForm(state);
                    },
                  ),
                  _buildField(
                    controller: _loanAmountController,
                    label: 'Required Loan Amount (₹) *',
                    icon: Icons.account_balance_wallet_outlined,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.done,
                    inputFormatters: _amountInputFormatters,
                    validator: LoanFormValidators.requiredLoanAmount,
                    onChanged: (value) {
                      cubit.requiredLoanAmountChanged(value);
                      _revalidateForm(state);
                    },
                    onFieldSubmitted:
                        state.isLoading ? null : _checkEligibility,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _checkEligibility,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B3D91),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Check Eligibility',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
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
