import 'package:flutter/material.dart';

import '../../models/loan_application_data.dart';

class LoanFormState {
  const LoanFormState({
    this.form = const LoanFormFields(),
    this.autovalidateMode = AutovalidateMode.disabled,
    this.application,
    this.eligibilityResult,
    this.isLoading = false,
  });

  final LoanFormFields form;
  final AutovalidateMode autovalidateMode;
  final LoanApplicationData? application;
  final EligibilityResult? eligibilityResult;
  final bool isLoading;

  LoanFormState copyWith({
    LoanFormFields? form,
    AutovalidateMode? autovalidateMode,
    LoanApplicationData? application,
    EligibilityResult? eligibilityResult,
    bool? isLoading,
    bool clearEligibility = false,
  }) {
    return LoanFormState(
      form: form ?? this.form,
      autovalidateMode: autovalidateMode ?? this.autovalidateMode,
      application: clearEligibility ? null : application ?? this.application,
      eligibilityResult:
          clearEligibility ? null : eligibilityResult ?? this.eligibilityResult,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
