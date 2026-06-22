import 'package:flutter_test/flutter_test.dart';
import 'package:loan_application_form/cubit/loan_form_cubit.dart';

void main() {
  test('LoanFormCubit updates fields and checks eligibility', () async {
    final cubit = LoanFormCubit();

    cubit.fullNameChanged('John Doe');
    cubit.mobileNumberChanged('9876543210');
    cubit.monthlyIncomeChanged('80000');
    cubit.existingEmiChanged('10000');
    cubit.requiredLoanAmountChanged('500000');

    expect(cubit.state.form.fullName, 'John Doe');
    expect(cubit.state.form.mobileNumber, '9876543210');

    final result = await cubit.checkEligibility();

    expect(result, isNotNull);
    expect(cubit.state.application, isNotNull);
    expect(cubit.state.eligibilityResult, isNotNull);
    expect(cubit.state.eligibilityResult!.isEligible, isTrue);
    expect(cubit.state.isLoading, isFalse);

    await cubit.close();
  });
}
