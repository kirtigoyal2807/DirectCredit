import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/loan_application_data.dart';
import '../services/eligibility_service.dart';
import 'loan_form_state.dart';

class LoanFormCubit extends Cubit<LoanFormState> {
  LoanFormCubit() : super(const LoanFormState());

  void fullNameChanged(String value) {
    emit(state.copyWith(form: state.form.copyWith(fullName: value)));
  }

  void mobileNumberChanged(String value) {
    emit(state.copyWith(form: state.form.copyWith(mobileNumber: value)));
  }

  void monthlyIncomeChanged(String value) {
    emit(state.copyWith(form: state.form.copyWith(monthlyIncome: value)));
  }

  void existingEmiChanged(String value) {
    emit(state.copyWith(form: state.form.copyWith(existingEmi: value)));
  }

  void requiredLoanAmountChanged(String value) {
    emit(state.copyWith(
      form: state.form.copyWith(requiredLoanAmount: value),
    ));
  }

  void enableAutoValidate() {
    emit(state.copyWith(autovalidateMode: AutovalidateMode.onUserInteraction));
  }

  Future<EligibilityResult?> checkEligibility() async {
    emit(state.copyWith(isLoading: true, clearEligibility: true));

    await Future<void>.delayed(const Duration(milliseconds: 400));

    final data = state.form.toApplicationData();
    final result = EligibilityService.check(data);

    emit(state.copyWith(
      isLoading: false,
      application: data,
      eligibilityResult: result,
    ));

    return result;
  }

  void resetEligibility() {
    emit(state.copyWith(clearEligibility: true));
  }
}
